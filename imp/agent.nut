function handle(req, res) {
    try {
        device.send("color", req.query.color)

        res.send(200, "Color set")
    }
    catch (err) {
        res.send(500, req.body)
    }
}

http.onrequest(handle)