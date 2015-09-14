function colorImp() {
    var req = new XMLHttpRequest()
    req.open('GET', 'https://agent.electricimp.com/5ZWRjqrJHOjn', true)

    req.onload = function() {
        if (this.status >= 200 && this.status < 400) {
            var data = JSON.parse(this.response);
        }
        else {

        }
    }

    req.onerror = function() {}

    req.send()
}