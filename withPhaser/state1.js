var demo = {}, centerX = 1920 /2, centerY = 1024 / 2;
var scaleFactor = 1;
var mouse, world;

demo.state1 = function(){};
demo.state1.prototype = {
	preload: function(){
		game.time.advancedTiming = true;

		game.load.image("green", "assets/green.png");
		game.load.image("blue", "assets/blue.png");
		game.load.image("pink", "assets/pink.png");
		game.load.image("yellow", "assets/yellow.png");
		game.scale.scaleMode = Phaser.ScaleManager.SHOW_ALL;

		mouse = new Phaser.Mouse(game);
	},
	create: function(){
		/*var green = game.add.sprite(centerX, centerY, "green");
		var blue = game.add.sprite(centerX + size * 3 / 4, centerY - Math.sqrt(3) * size / 4, "blue");
		var pink = game.add.sprite(centerX, centerY - Math.sqrt(3) * size / 2, "pink");
		var yellow = game.add.sprite(centerX - size * 3 /4, centerY - Math.sqrt(3) * size /4, "yellow");

		green.anchor.setTo(0.5,0.5);
		blue.anchor.setTo(0.5,0.5);
		pink.anchor.setTo(0.5,0.5);
		yellow.anchor.setTo(0.5,0.5);
		green.scale.setTo(scaleFactor,scaleFactor);
		blue.scale.setTo(scaleFactor,scaleFactor);
		pink.scale.setTo(scaleFactor,scaleFactor);
		yellow.scale.setTo(scaleFactor,scaleFactor);*/


		world = buildWorld();

		//grid(100,100);

	},
	update: function(){
		
		
		if(game.input.mousePointer.isDown)
		{
			var x = game.input.mousePointer.x, y = game.input.mousePointer.y;
			console.log(x);
			console.log(y);
			var i, j;
			console.log(worldWidth);
			console.log(worldHeight);
			var finded = false;
			for(i = 0; i < worldWidth; i++)
			{
				console.log(i);
				for(j = 0; j < worldHeight; j++)
				{
					console.log(j);
					if(world[i][j].children[0].containsPoint(new Phaser.Point(x, y)))
					{
						finded = true;
						break;
					}
				}
				if(finded)
					break;
			}
			console.log(i);
			console.log(j);

			if(finded)
			{
				world[i][j].children[0].graphicsData[0].lineWidth = 5;
				world[i][j].children[0].graphicsData[0].lineColor = 0x789456;
			}
		}
		
	},
	render: function()
	{
		game.debug.text(game.time.fps || '--', 2, 14, "#00ff00"); 
	}
};