var worldWidth = 20, worldHeight = 20;
var size = 23;

var colors = {
	"ocean": 0x448cff,
	"green": 0x36db54,
	"pink": 0xea2ec1,
	"orange": 0xea982d,
	"yellow": 0xeadd2c
};

var frontierColor = 0x000000;

function plotHex(x, y, color) {
	var p0 = new Phaser.Point(x * 3 * size / 2  + size / 2, y * size * Math.sqrt(3) + (x % 2) * size * Math.sqrt(3) / 2);
	var p1 = new Phaser.Point(x * 3 * size / 2 + 3 * size / 2, y * size * Math.sqrt(3) + (x % 2) * size * Math.sqrt(3) / 2);
	var p2 = new Phaser.Point(x * 3 * size / 2, y * size * Math.sqrt(3) + size * Math.sqrt(3) / 2 + (x % 2) * size * Math.sqrt(3) / 2);
	var p3 = new Phaser.Point(x * 3 * size / 2 + 2 * size, y * size * Math.sqrt(3) + size * Math.sqrt(3) / 2 + (x % 2) * size * Math.sqrt(3) / 2);
	var p4 = new Phaser.Point(x * 3 * size / 2  + size / 2, y * size * Math.sqrt(3) + size * Math.sqrt(3) + (x % 2) * size * Math.sqrt(3) / 2);
	var p5 = new Phaser.Point(x * 3 * size / 2 + 3 * size / 2, y * size * Math.sqrt(3) + size * Math.sqrt(3) + (x % 2) * size * Math.sqrt(3) / 2);
	var hex = new Phaser.Polygon([ p2, p0, p1 , p3 , p5 , p4]);

	var sprite = game.add.sprite();
	var graphics = game.add.graphics(0,0);
	graphics.beginFill(color);
	graphics.lineStyle(0,0x000000);
	graphics.drawPolygon(hex.points);
	graphics.endFill();

	sprite.addChild(graphics);

	return sprite;
}


function buildWorld(){
	var world = new Object();
	for(var i = 0; i < worldWidth; i++)
	{
		world[i] = new Object();
		for(var j = 0; j< worldHeight; j++)
		{
			var key = Math.floor(Math.random() * Object.keys(colors).length);
			var color = colors[Object.keys(colors)[key]];

			world[i][j] = plotHex(i,j, color);
		}
	}

	return world;

}


/*var tileWidth = 2 * size, tileHeight = tileWidth * Math.sqrt(3) / 2;
//var scaleFactor = 0.25;

function tileCenter(x, y) {
	return {
			"centerX": tileWidth * 3 * x / 4 + tileWidth / 2,
			"centerY": tileHeight * y + tileHeight / 2  + (x % 2) * tileHeight / 2
		};
}

var colors = ["blue", "pink", "green", "yellow"];
function grid(nx, ny) {

	for(var i = 0; i < nx; i++)
	{
		for(var j = 0; j < ny; j++)
		{
			var key = Math.floor(Math.random() * colors.length);
			var color = colors[key];
			var center = tileCenter(i,j);

			if (color != "empty")
			{
				var tile = game.add.sprite(center["centerX"] * scaleFactor, center["centerY"]* scaleFactor, color);
				tile.anchor.setTo(0.5,0.5);
				tile.scale.setTo(scaleFactor);
			}
		}
	}
}

function clickHex(){
	var x = game.input.mousePointer.x, y = game.input.mousePointer.y;

	//console.log(x);
	//console.log(y);
	return {
		"coordX": x,
		"coordY": y
	};
}

function hexCoord(coordX, coordY){
	var x = coordX  * 4 / (tileWidth * 3);
	var y = (coordY - (x % 2) * tileHeight /2) / tileHeight;
	console.log(Math.trunc(x));
	console.log(Math.trunc(y));

}*/


