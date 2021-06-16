
import hsluv.Hsluv;
import js.Syntax;
import om.Browser;
import om.Browser.document;
import om.Browser.window;
import om.Random;

var colors : Array<Array<String>>;
var svgStr : String;

@:expose
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

	//trace(backS,darkL,rangeL);

	fg[0] = Hsluv.hsluvToHex( [H[ 4 ], 70, darkL + rangeL * Math.pow(3 / 6, 1.5)] );
	fg[1] = Hsluv.hsluvToHex( [H[ 3 ], 50, darkL + rangeL * Math.pow(2 / 6, 1.5)] );
	fg[2] = Hsluv.hsluvToHex( [H[ 3 ], 50, darkL + rangeL * Math.pow(1 / 6, 1.5)] );
	//fg[3] = Hsluv.hsluvToHex( [H[ 4 ], 50, darkL + rangeL * Math.pow(0 / 6, 1.5)] );
	fg[3] = bg[2];
	bg[4] = fg[0];

	colors = [bg,fg];

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

	svgStr = '<svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="100%" height="100%" viewBox="0 0 96 64">
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

	document.body.querySelector('main').innerHTML = svgStr;
}

@:expose
function exportSVG( name = "theme.svg" ) {
	Browser.saveTextFile( name, svgStr );
}

@:expose
function exportGPL( name = "theme.gpl" ) {
	var gplColors = new Array<om.color.GimpPalette.Color>();
	function add( name : String, color : String ) {
		var rgb = hexToRgb( color );
		gplColors.push({ name : name, r: rgb[0], g: rgb[1], b: rgb[2] });
	}
	add( 'background', colors[0][0] );
	add( 'f_high', colors[1][0] );
	add( 'f_med', colors[1][1] );
	add( 'f_low', colors[1][2] );
	add( 'f_inv', colors[1][3] );
	add( 'b_high', colors[0][1] );
	add( 'b_med', colors[0][2] );
	add( 'b_low', colors[0][3] );
	add( 'b_inv', colors[0][4] );
	var gpl = new om.color.GimpPalette( 'husl', 1,gplColors );
	Browser.saveTextFile( name, gpl.toString() );
}

@:expose
function exportCSS( name = "theme.css" ) {
	var css = ':root {\n';
	css += '\t--background: ${colors[0][0]};\n';
	css += '\t--f_high: ${colors[1][0]};\n';
	css += '\t--f_med: ${colors[1][1]};\n';
	css += '\t--f_low: ${colors[1][2]};\n';
	css += '\t--f_inv: ${colors[1][3]};\n';
	css += '\t--b_high: ${colors[0][1]};\n';
	css += '\t--b_med: ${colors[0][2]};\n';
	css += '\t--b_low: ${colors[0][3]};\n';
	css += '\t--b_inv: ${colors[0][4]};\n';
	css += '}\n';
	Browser.saveTextFile( name, css );
}

inline function getRandomInt( min : Int, max : Int )
	return Random.int( max - min ) + min;

function hexToRgb( hex : String ) : Array<Int> {
	var ereg = ~/^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i;
	if( !ereg.match( hex ) )
		return null;
	return [
		Syntax.code( "parseInt({0},16)", ereg.matched(1) ),
		Syntax.code( "parseInt({0},16)", ereg.matched(2) ),
		Syntax.code( "parseInt({0},16)", ereg.matched(3) ),
	];
}

function main() {
	window.onkeydown = e -> switch e.key {
	case _:  generate();
	}
	document.body.querySelector('main').onclick = e -> generate();
	//document.onwheel = generate;
	/* document.oncontextmenu =e -> {
		e.preventDefault();
		generate();
	} */
	generate();
	document.body.querySelector('header>button[name="gpl"]').onclick = e -> exportGPL();
	document.body.querySelector('header>button[name="svg"]').onclick = e -> exportSVG();
	document.body.querySelector('header>button[name="css"]').onclick = e -> exportCSS();
}
