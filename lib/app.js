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
        //due: due.toISOString(),
    }
});