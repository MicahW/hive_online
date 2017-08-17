
/* ------------------GLOBAL VARIABLES----------------------- */

var c = document.getElementById("myCanvas");
var yours = document.getElementById("yours");
var others = document.getElementById("others");
/* graphics set up */
var hexigon_size = 35;
var rect = c.getBoundingClientRect();
var y_canvas = rect.top + 1;
var x_canvas = rect.left + 1;
var x_offset = 100;
var y_offset = 100;

/* game setup */
game = new Game("white");


/* mouse globals */
var Xclicked;
var Yclicked;
var Qselect = null;
var Rselect = null;
var dragging = false;

var held_selected = false;
var held_number = 0;

var piece_selected = false;
var q_selected;
var r_selected;

/* images */
var img_arr = get_img_arr();



/* setup  */
var height = c.height;
var width = c.width;
var ctx = c.getContext("2d");
var your_ctx = yours.getContext("2d");
var other_ctx = others.getContext("2d");

setTimeout(function() {
	draw_all(ctx, []);
}, 100);



/* get array of all piece images */
function get_img_arr() {

	var w_bee = new Image();
	w_bee.src = "/assets/bee.png";
	
	var w_ant = new Image();
	w_ant.src = "/assetsant.png";

	var w_grasshopper = new Image();
	w_grasshopper.src = "/assetsgrasshopper.png";

	var w_spider = new Image();
	w_spider.src = "/assetsspider.png";

	var w_beatle = new Image();
	w_beatle.src = "/assetsbeatle.png";
	
	var img_arr = [w_bee, w_ant, w_grasshopper, w_spider, w_beatle];
	return img_arr;
}


/* ----------------INTERFACE AND GRAPHICS FUNCTIONS ---------------------*/


/* draw all pies to screen */
function draw_all(ctx, move_list) {
	
	ctx.clearRect(0, 0, width, height);
	other_ctx.clearRect(0, 0, width, height);
	your_ctx.clearRect(0, 0, width, height);

	ctx.beginPath();
	
	/* draw each level at a time, keep a list of aboves */
	var level_list = game.board_list;
	var level = 0;
	while (level_list.length > 0) {
		var next_level = [];
		for (i = 0; i < level_list.length; i++) {
			piece = level_list[i];
			var draw_img = true;
			if (piece.above != null) {
				next_level.push(piece.above);
				draw_img = false;
			}
			hexigon(ctx, piece.q, piece.r, hexigon_size, draw_img, piece.code, piece.color, level);
		}
		level_list = next_level;
		level += 1;
	}
	
	ctx.strokeStyle = "black";
	ctx.stroke();
	
	ctx.beginPath();
	for (i = 0; i < move_list.length; i++) {
		hexigon(ctx, move_list[i][0], move_list[i][1], hexigon_size, false, 0, 0, 0)
	}
	
	
	
	ctx.strokeStyle = "blue";
	ctx.stroke();
	ctx.beginPath();
	
	your_ctx.beginPath();
	other_ctx.beginPath();
	/*now draw the hexigons from placment pool */
	for (i = 0; i< 5; i++) {
		xpos = i*150 +  200;
		draw_hexigon(other_ctx, xpos, 40, hexigon_size, true,  i, game.other_color, 0);
		other_ctx.font = "30px Arial";
		other_ctx.fillText("X " + game.other_left[i], xpos+50, 50);
	}
		
	for (i = 0; i< 5; i++) {
		xpos = i*150 +  200;
		draw_hexigon(your_ctx, xpos, 40, hexigon_size, true,  i, game.color, 0);
		your_ctx.font = "30px Arial";
		your_ctx.fillText("X " + game.your_left[i], xpos+50, 50);
	}
	
	your_ctx.strokeStyle = "black";
	your_ctx.stroke();
	other_ctx.strokeStyle = "black";
	other_ctx.stroke();
	
	your_ctx.beginPath();
	if (held_selected) {
		xpos = held_number*150 +  200;
		draw_hexigon(your_ctx, xpos, 40, hexigon_size, true,  held_number, "white", 0);
	}
	your_ctx.strokeStyle = "blue";
	your_ctx.stroke();
	
	
	
}	

/* draw a hexigon */
function draw_hexigon(ctx, x, y, size, img, code, color, level) {
	x += 6 * level;
	y -= 6 * level;
	var whole = size * (2.0/Math.sqrt(3))
	var half = whole / 2.0
	
	ctx.moveTo(x-whole, y)
	ctx.lineTo(x-half,y-size)
	ctx.lineTo(x+half, y-size)
	ctx.lineTo(x+whole, y)
	ctx.lineTo(x+half, y+size)
	ctx.lineTo(x-half, y+size)
	ctx.lineTo(x-whole, y)	
	if (img) {
		if (color === "black") {
			ctx.fill();
			ctx.beginPath();
		}
		ctx.drawImage(img_arr[code], x-(size) , y-(size), size*2, size*2 );
	}
}

/* draw hex with cord system */
function hexigon(ctx, x, y, h, img, code, color, level) {
	var w = h * (1.0/Math.sqrt(3))
	
	xpos = 3*w*x + x_offset;
	ypos = (2*h*y) + (h*x) + y_offset;
	draw_hexigon(ctx, xpos, ypos, h, img, code, color, level)
	
	
	/*
	ctx.font = "10px Arial";
	ctx.fillText(x + "," + y,xpos,ypos); */
}

/* take mouse inputs and convert to a hex in axial */
function getcords(x,y) {
	size = hexigon_size * (2.0/Math.sqrt(3))
	
	var q =  x * 2/3 / size
    var r = (-x / 3 + Math.sqrt(3)/3 * y) / size
	
	/* converty to cube */
	var cx = q
    var cz = r
    var cy = -cx-cz
	
	/* use hex round */
	var rx = Math.round(cx)
    var ry = Math.round(cy)
    var rz = Math.round(cz)

    var x_diff = Math.abs(rx - cx)
    var y_diff = Math.abs(ry - cy)
    var z_diff = Math.abs(rz - cz)

    if (x_diff > y_diff && x_diff > z_diff) {
        rx = -ry-rz
    } else if (y_diff > z_diff) {
        ry = -rx-rz
    } else {
        rz = -rx-ry
	}
	/* convert back to axial */
	
	q = rx
	r = rz
	
	return [q,r]
}



/* -------------------------EVNENT FUNCTIONS ------------------------------*/

/*funtion called on mouse move*/	
function drag(event) {
	/* mouse moved so draging, dont click */
		/* get position now */
	     
		var x = event.pageX - x_canvas - x_offset;
		var y = event.pageY - y_canvas - y_offset;
	
	    if (x != Xclicked || y != Yclicked) {
		  dragging = true;
		 	
		  x_offset -= (Xclicked - x);
		  y_offset -= (Yclicked - y);
		
	
		  Xclicked = x;
		  Yclicked = y;
		  draw_all(c.getContext("2d"), []);
		}
}
	
	
c.addEventListener('mouseup', function(event) {
	c.removeEventListener("mousemove", drag);
	if (!dragging) {
	var x = event.pageX - x_canvas - x_offset;
    var y = event.pageY - y_canvas - y_offset;
	
	cords = getcords(x,y)
	q = cords[0];
	r = cords[1];
	
	var move_list = [];
	
	if (!held_selected && !piece_selected && game.piece_at([q,r])) {
		/*a piece is not selected to place, and there is a hex here, 
		must be asking for movees list */
		piece_selected = true;
		q_selected = q;
		r_selected = r;
		
		
		if (q == Qselect && r == Rselect) {
			Qselect = null;
			Rselect = null;
		} else {	
			move_list = game.get_moves(q,r);
			Qselect = q;
			Rselect = r;
		}
	} else {
		/* a piece is primed for placing or clicked on a 
		empty space with nothing selected */
		if (held_selected) {
			game.place_piece(q,r,held_number);
			held_selected = false;
		} else if (piece_selected) {
			game.move_piece(q_selected, r_selected, q, r);
			piece_selected = false;
			
		}
		Qselect = null;
		Rselect = null;
		/* if clicked on empty space nothing will happen */
		
	}
	
	
	draw_all(ctx, move_list);
	
	
	
    var coords = "X coords: " + q + ", Y coords: " + r;
	document.getElementById("display").innerHTML = coords;
	}
	dragging = false;
}, false);

c.addEventListener('mousedown', function(event) {
	dragging = false;
	Xclicked = event.pageX - x_canvas - x_offset;
    Yclicked = event.pageY - y_canvas - y_offset;
	
	/* add a event lisener for dragging */
	c.addEventListener('mousemove', drag, false);	
}, false);	

/* mouse clicks for held pieces */
yours.addEventListener('click', function(event) {
	piece_selected = false;
	var r = yours.getBoundingClientRect();
	var x = event.pageX - rect.left + 1;
	var i = (x-200.0+hexigon_size)/150.0;
	i = Math.round(i);
	if (i > -1 && i < 5) {
		if (held_selected && held_number == i) {
			held_selected = false;
		} else {
			held_selected = true
			held_number = i;
		}
	}
	draw_all(ctx, []);
},false);
	


/* --------------DEFINE GAME OBJECTS------------------- */

/* game piece */
function Piece(code, q, r, color) {
	this.color = color;
	this.code = code;
	this.above = null;
	this.q = q;
	this.r = r;
};

	

function Game(color) {
	/* int code 0-4 for each peice */
	this.codes = ["bee", "ant", "grasshopper", "spider", "beatle"];
	/* hash of each board peice */
	this.board = {};
	/* list for board */
	this.board_list = [];

	/* how many of each are left in hand */
	this.your_count = 11;
	this.other_count = 11;
	this.your_left = [1,3,3,2,2];
	this.other_left = [1,3,3,2,2];
	
	this.color = color;
	this.other_color = color == "black" ? "white" : "black";
	
	/* gets the top piece */
	this.get_top_piece = function(q,r) {
		var piece = this.board[[q,r]];
		while(piece.above != null) {
			piece = piece.above;
		}
		return piece;
	}
	
	/* removes piece from board list */
	this.remove_piece_from_list = function(q,r) {
		var k;
		for (k = 0; k < this.board_list.length; k++) {
			if (this.board_list[k][0] == q && this.board_list[k][1] == r) {
				this.board_list.splice(k,1);
			}
		}
	}
	
	/* removes the top piece */
	this.remove_top_piece = function(q,r) {
		if (this.board[[q,r]].above == null) {
			this.remove_piece_from_list(q,r);
			this.board[[q,r]] = null;
		} else {
			var last_left = this.board[[q,r]];
			while (last_left.above.above != null) {
				last_left = last_left.above;
			}
			last_left.above = null;
		}
	}
	
	/* puts this piece on top */
	this.place_on_top = function(q,r,piece) {
		if (!this.piece_at([q,r])) {
			this.board[[q,r]] = piece
			this.board_list.push(piece);
		} else {
			var top_piece = this.get_top_piece(q,r);
			top_piece.above = piece;
			top_piece.above.above = null;	
		}
	}
			
	
	/* player is placing piece */
	this.place_piece = function(q,r,code) {
		/* ask server if valid */
		var piece = new Piece(code,q,r,this.color);
		this.your_count -= 1;
		this.your_left[piece.code] -= 1;
		this.place_on_top(q,r,piece);
	};
	
	/* player is moving piece */
	this.move_piece = function(q,r,to_q,to_r) {
		/*ask server if valid */
		var piece = this.get_top_piece(q,r);
		piece.q = to_q;
		piece.r = to_r;
		this.remove_top_piece(q,r);
	    this.place_on_top(to_q,to_r,piece);
	};
	
	/* is there a pice at these cords */
	this.piece_at = function(cords) {
		return this.board[cords] != null;
	};
	
	/* get a list of all moves this piece can make */
	/* right now just a list of niegbors */
	this.get_moves = function(q,r) {
		move_list = [];
		/* if the mouse if hovering over a selected hex */
		directions = [[q,r-1],[q+1,r-1],[q+1,r],[q,r+1],[q-1,r+1],[q-1,r]]
		for(i = 0; i < 6; i++) {
			if (!this.piece_at(directions[i])) {
				move_list.push(directions[i]);
			}
		}
		return move_list;
	};
}


































