r <- hardware.pin1
g <- hardware.pin2
b <- hardware.pin5

r.configure(PWM_OUT, 2e-3, 0.1)
g.configure(PWM_OUT, 2e-3, 0.1)
b.configure(PWM_OUT, 2e-3, 0.1)

rainbow <- [
    [255, 0, 0],
    [255, 255, 0],
    [0, 255, 0],
    [0, 255, 255],
    [0, 0, 255],
    [255, 0, 255],
]

solidColorMode <- false

function handleBong(color) {
    solidColorMode = true
    color = color.tointeger()
    color = [0xff0000&color, 0x00ff00&color, 0x0000ff&color]
    setColor(color)
}

agent.on("color", handleBong)

function setColor(color) {
    r.write(color[0]/255.0)
    g.write(color[2]/255.0)
    b.write(color[1]/255.0)
}

function lerp(v0, v1, t) {
    return (v0 + t*(v1-v0)).tointeger()
}

function clerp(c1, c2, t) {
    local resColor = [0, 0, 0]
    for (local i=0; i<3; i++)
        resColor[i] = lerp(c1[i], c2[i], t)
    return resColor
}

ct_c1 <- 0
ct_c2 <- 0
ct_start <- 0
ct_time <- 0
function colorTrans() {
    if (solidColorMode)
        return
    local time = ct_time*1e3
    local start = ct_start
    local t = 0
    local curtime = hardware.millis()
    if (curtime < start+time) {
        t = (curtime - start)/time
        setColor(clerp(ct_c1, ct_c2, t))
        
        curtime = hardware.millis()
        imp.wakeup(0.01, colorTrans)
    }
}

sw_i <- 0
sw_colors <- 0
sw_time <- 0
sw_repeat <- 0
function sweep() {
    if (solidColorMode)
        return
    // time in seconds
    local currentCol, nextC
    if (sw_i < sw_colors.len()-1) {
        ct_c1 = sw_colors[sw_i]
        ct_c2 = sw_colors[sw_i+1]
        ct_start = hardware.millis()
        ct_time = sw_time
        colorTrans()

        sw_i++
        imp.wakeup(sw_time, sweep)
    }
    else if (sw_i == sw_colors.len()-1) {
        ct_c1 = sw_colors[sw_colors.len()-1]
        ct_c2 = sw_colors[0]
        ct_start = hardware.millis()
        ct_time = sw_time
        colorTrans()

        if (sw_repeat) {
            sw_i = 0
            imp.wakeup(sw_time, sweep)
        }
    }
}

sw_i = 0
sw_colors = rainbow
sw_time = 4
sw_repeat = true
sweep()