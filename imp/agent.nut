function handle(req, res) {
    try {
        device.send("color", [0, 255, 0])

        res.send(200, "Color set")
    }
    catch (err) {
        response.send(500, err)
    }
}

http.onrequest(handle)