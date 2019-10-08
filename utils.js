function pad(num, size, character) {
    var schar = "0"
    if(character!==undefined)
        schar = character
    var s = num+"";
    while (s.length < size) s = schar + s;
    return s;
}

function numberWithCommas(x) {
    x = x.toLocaleString('fullwide', {useGrouping:false})
    var pattern = /(-?\d+)(\d{3})/;
    while (pattern.test(x))
        x = x.replace(pattern, "$1,$2");
    return x;
}

function gregorian_to_jalali(gy,gm,gd){
    var g_d_m=[0,31,59,90,120,151,181,212,243,273,304,334];
    var jy=(gy<=1600)?0:979;
    gy-=(gy<=1600)?621:1600;
    var gy2=(gm>2)?(gy+1):gy;
    var days=(365*gy) +(parseInt((gy2+3)/4)) -(parseInt((gy2+99)/100))
            +(parseInt((gy2+399)/400)) -80 +gd +g_d_m[gm-1];
    jy+=33*(parseInt(days/12053));
    days%=12053;
    jy+=4*(parseInt(days/1461));
    days%=1461;
    jy+=parseInt((days-1)/365);
    if(days > 365)days=(days-1)%365;
    var jm=(days < 186)?1+parseInt(days/31):7+parseInt((days-186)/30);
    var jd=1+((days < 186)?(days%31):((days-186)%30));
    return [jy,jm,jd];
}
