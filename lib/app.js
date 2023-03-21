const Order = Parse.Object.extend("Order");
const OrderItem = Parse.Object.extend("OrderItem");
const CartItem = Parse.Object.extend("CartItem");
const GnEvent = Parse.Object.extend('GnEvent');
const product = require('./product'); // usar o formatProduct com esse require

//GERENCIANET
var Gerencianet = require('gn-api-sdk-node');

var options = {
    sandbox: false,
    client_id: 'Client_Id_8a820faca3e624df8c154572c1e34ee6abaa063e',
    client_secret: 'Client_Secret_8ef5c421c918f851b5c06375617290aea9af405b',
    pix_cert: __dirname + '/certs/producao.p12'
};

var gerencianet = new Gerencianet(options);

Date.prototype.addSeconds = function (s) {
    this.setTime(this.getTime() + (s * 1000));
    return this;
}


//Pedido
//Verifica o que tem no carrinho pega o total dos items e cria um pedido
Parse.Cloud.define("checkout", async (req) => {
    if (req.user == null) throw 'INVALID_USER';

    const queryCartItems = new Parse.Query(CartItem);
    queryCartItems.equalTo('user', req.user);
    queryCartItems.include('product');
    const resultCartItems = await queryCartItems.find({ useMasterKey: true });

    let total = 0;
    for (let item of resultCartItems) {
        item = item.toJSON();
        total += item.quantity * item.product.price;
    }

    if (req.params.total != total) throw 'INVALID_TOTAL';

    const dueSeconds = 3600;
    const due = new Date().addSeconds(dueSeconds);

    const charge = await createCharge(dueSeconds, req.user.get('cpf'), req.user.get('fullname'), total);
    const qrCodeData = await generateQRCode(charge.loc.id);

    const order = new Order();
    order.set('total', total);
    order.set('user', req.user);
    order.set('dueDate', due);
    order.set('qrCodeImage', qrCodeData.imagemQrcode);
    order.set('qrCode', qrCodeData.qrcode);
    order.set('txid', charge.txid);
    order.set('status', 'pending_payment');
    const savedOrder = await order.save(null, { useMasterKey: true });

    for (let item of resultCartItems) {
        const orderItem = new OrderItem();
        orderItem.set('order', savedOrder);
        orderItem.set('user', req.user);
        orderItem.set('product', item.get('product'));
        orderItem.set('quantity', item.get('quantity'));
        orderItem.set('price', item.toJSON().product.price);
        await orderItem.save(null, { useMasterKey: true });
    }

    await Parse.Object.destroyAll(resultCartItems, { useMasterKey: true });

    return {
        id: savedOrder.id,
        total: total,
        qrCodeImage: qrCodeData.imagemQrcode,
        copiaecola: qrCodeData.qrcode,
        due: due.toISOString(),
        status: 'pending_payment',
    }
});





Parse.Cloud.define("checkestoque", async (req) => {
    if (req.user == null) throw 'INVALID_USER';

    const queryCartItems = new Parse.Query(CartItem);
    queryCartItems.equalTo('user', req.user);
    queryCartItems.include('product');
    const resultCartItems = await queryCartItems.find({ useMasterKey: true });

    let total = 0.01;

    if (req.params.total != total) throw 'INVALID_TOTAL';

    const dueSeconds = 3600;
    const due = new Date().addSeconds(dueSeconds);

    const charge = await createCharge(dueSeconds, req.user.get('cpf'), req.user.get('fullname'), total);
    const qrCodeData = await generateQRCode(charge.loc.id);

    const order = new Order();
    order.set('total', total);
    order.set('user', req.user);
    order.set('dueDate', due);
    order.set('qrCodeImage', qrCodeData.imagemQrcode);
    order.set('qrCode', qrCodeData.qrcode);
    order.set('txid', charge.txid);
    order.set('status', 'pending_payment');
    const savedOrder = await order.save(null, { useMasterKey: true });

    for (let item of resultCartItems) {
        const orderItem = new OrderItem();
        orderItem.set('order', savedOrder);
        orderItem.set('user', req.user);
        orderItem.set('product', item.get('product'));
        orderItem.set('quantity', item.get('quantity'));
        orderItem.set('price', item.toJSON().product.price);
        await orderItem.save(null, { useMasterKey: true });
    }

    await Parse.Object.destroyAll(resultCartItems, { useMasterKey: true });

    return {
        id: savedOrder.id,
        total: total,
        qrCodeImage: qrCodeData.imagemQrcode,
        copiaecola: qrCodeData.qrcode,
        due: due.toISOString(),
        status: 'pending_payment',
    }
});

//Pega todos os pedidos
Parse.Cloud.define("get-orders", async (req) => {
    const queryOrders = new Parse.Query(Order);
    queryOrders.equalTo("user", req.user);
    const resultOrders = await queryOrders.find();
    return resultOrders.map(function (o) {
        o = o.toJSON();
        return {
            id: o.objectId,
            total: o.total,
            createdAt: o.createdAt,
            due: o.dueDate,
            qrCodeImage: o.qrCodeImage,
            copiaecola: o.qrCode,
            status: o.status,
        }
    });
});

//Pega todos os pedidos com Items
Parse.Cloud.define('get-order-items', async (req) => {
    if (req.user == null) throw 'INVALID_USER';
    if (req.params.orderId == null) throw 'INVALID_ORDER';

    const order = new Order();
    order.id = req.params.orderId;

    const queryOrderItems = new Parse.Query(OrderItem);
    queryOrderItems.equalTo('order', order);
    queryOrderItems.equalTo('user', req.user);
    queryOrderItems.include('product');
    queryOrderItems.include('product.category');
    const resultOrderItems = await queryOrderItems.find({ useMasterKey: true });
    return resultOrderItems.map(function (o) {
        o = o.toJSON();
        return {
            id: o.objectId,
            quantity: o.quantity,
            price: o.price,
            product: {
                title: o.product.title,
                description: o.product.description,
                createdAt: o.product.createdAt
            }
            //product: product.formatProduct(o.product)
        }
    });
});

Parse.Cloud.define('webhook', async (req) => {
    if (req.user == null) throw 'INVALID_USER';
    if (req.user.id != 'azPOBah2s8') throw 'INVALID_USER';
    return 'Olá mundo!';
});

Parse.Cloud.define('pix', async (req) => {
    if (req.user == null) throw 'INVALID_USER';
    //if(req.user.id != 'IuXnTst0E6') throw 'INVALID_USER';

    for (const e of req.params.pix) {
        const gnEvent = new GnEvent();
        gnEvent.set('eid', e.endToEndId);
        gnEvent.set('txid', e.txid);
        gnEvent.set('event', e);
        await gnEvent.save(null, { useMasterKey: true });

        const query = new Parse.Query(Order);
        query.equalTo('txid', e.txid);

        const order = await query.first({ useMasterKey: true });
        if (order == null) {
            throw 'NOT_FOUND';
        }

        order.set('status', 'paid');
        order.set('e2eId', e.endToEndId);

        await order.save(null, { useMasterKey: true });
    }
});

Parse.Cloud.define('config-webhook', async (req) => {
    let body = {
        "webhookUrl": "https://api.cscgnet.cloudns.nz/prod/webhook"
    }

    let params = {
        chave: "17338eab-cdcc-4997-82ff-009d03631861"
    }

    return await gerencianet.pixConfigWebhook(params, body);
});

async function createCharge(dueSeconds, cpf, fullname, price) {
    let body = {
        calendario: {
            expiracao: dueSeconds,
        },
        devedor: {
            cpf: cpf.replace(/\D/g, ''),
            nome: fullname,
        },
        valor: {
            original: price.toFixed(2),
        },
        chave: '17338eab-cdcc-4997-82ff-009d03631861', // Informe sua chave Pix cadastrada na gerencianet	
        infoAdicionais: [
            {
                nome: 'Pagamento em',
                valor: 'NOME DO SEU ESTABELECIMENTO',
            },
            {
                nome: 'Pedido',
                valor: 'NUMERO DO PEDIDO DO CLIENTE',
            },
        ],
    }

    const gerencianet = new Gerencianet(options)

    const response = await gerencianet.pixCreateImmediateCharge([], body);
    return response;
}

//Gera o QRCODE e PIX copia/cola
async function generateQRCode(locId) {
    let params = {
        id: locId,
    }

    const response = await gerencianet.pixGenerateQRCode(params);
    return response;
}
