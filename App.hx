
import hsluv.Hsluv;
import js.Browser.document;
import js.Browser.window;
import js.html.svg.SVGElement;
import js.html.DOMParser;

function generate() {

	//var invertInv = true;
	
	var h = getRandomInt( 0, 360 );
	var H : Array<Int> = ([0,60,120,180,240,300]).map( offset -> return (h + offset) % 360 );

	var bg = [];
	var backS = getRandomInt( 5, 40 );
	var darkL = getRandomInt( 0, 10 );
	var rangeL = 90 - darkL;
	for( i in 0...5 ) {
		bg.push( Hsluv.hsluvToHex( [H[0], backS, darkL + rangeL * Math.pow(i / 7, 1.5)] ) );
	}
	
	var fg = [];
	var backS = getRandomInt( 20, 70 );
	var darkL = getRandomInt( 10, 50 );
	var rangeL = 100 - darkL;

	trace(backS,darkL,rangeL);

	fg[0] = Hsluv.hsluvToHex( [H[ 4 ], 70, darkL + rangeL * Math.pow(3 / 6, 1.5)] );
	fg[1] = Hsluv.hsluvToHex( [H[ 3 ], 50, darkL + rangeL * Math.pow(2 / 6, 1.5)] );
	fg[2] = Hsluv.hsluvToHex( [H[ 3 ], 50, darkL + rangeL * Math.pow(1 / 6, 1.5)] );
	//fg[3] = Hsluv.hsluvToHex( [H[ 4 ], 50, darkL + rangeL * Math.pow(0 / 6, 1.5)] );
	fg[3] = bg[2];
	bg[4] = fg[0];

	trace(bg,fg);

	/*
	var minS = getRandomInt( 30, 70 );
	var maxS = minS + 30;
	var minL = getRandomInt( 50, 70 );
	var maxL = minL + 20;
	for( j in 0...4 ) {
		var _h = H[ getRandomInt( 0, 5 ) ];
		var _s = getRandomInt( minS, maxS );
		var _l = getRandomInt( minL, maxL );
		fg.push( Hsluv.hsluvToHex( [_h,_s,_l] ) );
	}
	*/

	document.body.style.background = bg[0];

	/* var svg = new DOMParser().parseFromString('<svg xmlns="http://www.w3.org/2000/svg" version="1.1">
	<rect width="96" height="64" id="background" fill="${bg[0]}"></rect>
	<!-- Foreground -->
	<circle cx="24" cy="24" r="8" id="f_high" fill="${fg[0]}"></circle>
	<circle cx="40" cy="24" r="8" id="f_med" fill="${fg[1]}"></circle>
	<circle cx="56" cy="24" r="8" id="f_low" fill="${fg[2]}"></circle>
	<circle cx="72" cy="24" r="8" id="f_inv" fill="${fg[3]}"></circle>
	<!-- Background -->
	<circle cx="24" cy="40" r="8" id="b_high" fill="${bg[1]}"></circle>
	<circle cx="40" cy="40" r="8" id="b_med" fill="${bg[2]}"></circle>
	<circle cx="56" cy="40" r="8" id="b_low" fill="${bg[3]}"></circle>
	<circle cx="72" cy="40" r="8" id="b_inv" fill="${bg[4]}"></circle>
  </svg>', IMAGE_SVG_XML ).getElementsByTagNameNS("http://www.w3.org/2000/svg", "svg").item(0); */
	// document.body.append( svg );

	document.body.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="100%" height="100%" viewBox="0 0 96 48">
	<rect width="96" height="64" id="background" fill="${bg[0]}"></rect>
	<!-- Foreground -->
	<circle cx="24" cy="24" r="8" id="f_high" fill="${fg[0]}"></circle>
	<circle cx="40" cy="24" r="8" id="f_med" fill="${fg[1]}"></circle>
	<circle cx="56" cy="24" r="8" id="f_low" fill="${fg[2]}"></circle>
	<circle cx="72" cy="24" r="8" id="f_inv" fill="${fg[3]}"></circle>
	<!-- Background -->
	<circle cx="24" cy="40" r="8" id="b_high" fill="${bg[1]}"></circle>
	<circle cx="40" cy="40" r="8" id="b_med" fill="${bg[2]}"></circle>
	<circle cx="56" cy="40" r="8" id="b_low" fill="${bg[3]}"></circle>
	<circle cx="72" cy="40" r="8" id="b_inv" fill="${bg[4]}"></circle>
  </svg>';
}

inline function getRandomInt( min : Int, max : Int )
	return om.Random.int( max - min ) + min;

function main() {
	window.onkeydown = generate;
	/*e -> switch e.key {
	case "r": generate();
	case _:
	}
	*/
	document.onclick = generate;
	document.onwheel = generate;
	/* document.oncontextmenu =e -> {
		e.preventDefault();
		generate();
	} */
	generate();
}
