var game = new Phaser.Game(1920, 1024, Phaser.CANVAS);

game.state.add("state1", demo.state1);
game.state.start("state1");