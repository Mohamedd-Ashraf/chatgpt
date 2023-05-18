var bestMove = -1;
var bestScore = [-Infinity, -Infinity, -Infinity, -Infinity, -Infinity, -Infinity, -Infinity, -Infinity, -Infinity];
int realEvaluateSquare(List<int> pos) {
double evaluation = 0;
List<double> points = [0.2, 0.17, 0.2, 0.17, 0.22, 0.17, 0.2, 0.17, 0.2];

for(int bw in pos.asMap().keys){
evaluation -= pos[bw] * points[bw];
}

int a = 2;
if(pos[0] + pos[1] + pos[2] == a || pos[3] + pos[4] + pos[5] == a || pos[6] + pos[7] + pos[8] == a) {
evaluation -= 6;
}
if(pos[0] + pos[3] + pos[6] == a || pos[1] + pos[4] + pos[7] == a || pos[2] + pos[5] + pos[8] == a) {
evaluation -= 6;
}
if(pos[0] + pos[4] + pos[8] == a || pos[2] + pos[4] + pos[6] == a) {
evaluation -= 7;
}

a = -1;
if((pos[0] + pos[1] == 2 * a && pos[2] == -a) || (pos[1] + pos[2] == 2 * a && pos[0] == -a) || (pos[0] + pos[2] == 2 * a && pos[1] == -a)
|| (pos[3] + pos[4] == 2 * a && pos[5] == -a) || (pos[3] + pos[5] == 2 * a && pos[4] == -a) || (pos[5] + pos[4] == 2 * a && pos[3] == -a)
|| (pos[6] + pos[7] == 2 * a && pos[8] == -a) || (pos[6] + pos[8] == 2 * a && pos[7] == -a) || (pos[7] + pos[8] == 2 * a && pos[6] == -a)
|| (pos[0] + pos[3] == 2 * a && pos[6] == -a) || (pos[0] + pos[6] == 2 * a && pos[3] == -a) || (pos[3] + pos[6] == 2 * a && pos[0] == -a)
|| (pos[1] + pos[4] == 2 * a && pos[7] == -a) || (pos[1] + pos[7] == 2 * a && pos[4] == -a) || (pos[4] + pos[7] == 2 * a && pos[1] == -a)
|| (pos[2] + pos[5] == 2 * a && pos[8] == -a) || (pos[2] + pos[8] == 2 * a && pos[5] == -a) || (pos[5] + pos[8] == 2 * a && pos[2] == -a)
|| (pos[0] + pos[4] == 2 * a && pos[8] == -a) ||        (pos[0] + pos[8] == 2 * a && pos[4] == -a) || (pos[4] + pos[8] == 2 * a && pos[0] == -a)
        || (pos[2] + pos[4] == 2 * a && pos[6] == -a) || (pos[2] + pos[6] == 2 * a && pos[4] == -a) || (pos[4] + pos[6] == 2 * a && pos[2] == -a)) {
      evaluation -= 9;
    }

    a = -2;
    if (pos[0] + pos[1] + pos[2] == a || pos[3] + pos[4] + pos[5] == a || pos[6] + pos[7] + pos[8] == a) {
      evaluation += 6;
    }
    if (pos[0] + pos[3] + pos[6] == a || pos[1] + pos[4] + pos[7] == a || pos[2] + pos[5] + pos[8] == a) {
      evaluation += 6;
    }
    if (pos[0] + pos[4] + pos[8] == a || pos[2] + pos[4] + pos[6] == a) {
      evaluation += 7;
    }

    a = 1;
    if ((pos[0] + pos[1] == 2 * a && pos[2] == -a) || (pos[1] + pos[2] == 2 * a && pos[0] == -a) || (pos[0] + pos[2] == 2 * a && pos[1] == -a)
        || (pos[3] + pos[4] == 2 * a && pos[5] == -a) || (pos[3] + pos[5] == 2 * a && pos[4] == -a) || (pos[5] + pos[4] == 2 * a && pos[3] == -a)
        || (pos[6] + pos[7] == 2 * a && pos[8] == -a) || (pos[6] + pos[8] == 2 * a && pos[7] == -a) || (pos[7] + pos[8] == 2 * a && pos[6] == -a)
        || (pos[0] + pos[3] == 2 * a && pos[6] == -a) || (pos[0] + pos[6] == 2 * a && pos[3] == -a) || (pos[3] + pos[6] == 2 * a && pos[0] == -a)
        || (pos[1] + pos[4] == 2 * a && pos[7] == -a) || (pos[1] + pos[7] == 2 * a && pos[4] == -a) || (pos[4] + pos[7] == 2 * a && pos[1] == -a)
        || (pos[2] + pos[5] == 2 * a && pos[8] == -a) || (pos[2] + pos[8] == 2 * a && pos[5] == -a) || (pos[5] + pos[8] == 2 * a && pos[2] == -a)
        || (pos[0] + pos[4] == 2 * a && pos[8] == -a) || (pos[0] + pos[8] == 2 * a && pos[4] == -a) || (pos[4] + pos[8] == 2 * a && pos[0] == -a)
        || (pos[2] + pos[4] == 2 * a && pos[6] == -a) || (pos[2] + pos[6] == 2 * a && pos[4] == -a) || (pos[4] + pos[6] == 2 * a && pos[2] == -a)) {
      evaluation -= 9;
    }

    evaluation -= checkWinCondition(pos) * 12;

    return evaluation as int;
}

function game(){
    //BG FILL
    ctx.fillStyle = COLORS.white;
    ctx.fillRect(0, 0, WIDTH, HEIGHT);

    ctx.lineWidth = 3;
    var squareSize = WIDTH/4;

    //AI HANDLER

    if(currentTurn === -1 && gameRunning && AIACTIVE){

        console.log("Start AI");
        //document.getElementById("loader").removeAttribute('hidden');

        bestMove = -1;
        bestScore = [-Infinity, -Infinity, -Infinity, -Infinity, -Infinity, -Infinity, -Infinity, -Infinity, -Infinity];

        RUNS = 0; //Just a variable where I store how many times minimax has run

        //Calculates the remaining amount of empty squares
        var count = 0;
        for(var bt = 0; bt < boards.length; bt++){
            if(checkWinCondition(boards[bt]) === 0){
                boards[bt].forEach((v) => (v === 0 && count++));
            }
        }


        if(currentBoard === -1 || checkWinCondition(boards[currentBoard]) !== 0){
            var savedMm;

            console.log("Remaining: " + count);

            //This minimax doesn't actually play a move, it simply figures out which board you should play on
            if(MOVES < 10) {
                savedMm = miniMax(boards, -1, Math.min(4, count), -Infinity, Infinity, true); //Putting math.min makes sure that minimax doesn't run when the board is full
            }else if(MOVES < 18){
                savedMm = miniMax(boards, -1, Math.min(5, count), -Infinity, Infinity, true);
            }else{
                savedMm = miniMax(boards, -1, Math.min(6, count), -Infinity, Infinity, true);
            }
            console.log(savedMm.tP);
            currentBoard = savedMm.tP;
        }

        //Just makes a quick default move for if all else fails
        for (var i = 0; i < 9; i++) {
            if (boards[currentBoard][i] === 0) {
                bestMove = i;
                break;
            }
        }


        if(bestMove !== -1) { //This condition should only be false if the board is full, but it's here in case

            //Best score is an array which contains individual scores for each square, here we're just changing them based on how good the move is on that one local board
            for (var a = 0; a < 9; a++) {
                if (boards[currentBoard][a] === 0) {
                    var score = evaluatePos(boards[currentBoard], a, currentTurn)*45;
                    bestScore[a] = score;
                }
            }

            //And here we actually run minimax and add those values to the array
            for(var b = 0; b < 9; b++){
                if(checkWinCondition(boards[currentBoard]) === 0){
                    if (boards[currentBoard][b] === 0) {
                        boards[currentBoard][b] = ai;
                        var savedMm;
                        //Notice the stacking, at the beginning of the game, the depth is much lower than at the end
                        if(MOVES < 20){
                            savedMm = miniMax(boards, b, Math.min(5, count), -Infinity, Infinity, false);
                        }else if(MOVES < 32){
                            console.log("DEEP SEARCH");
                            savedMm = miniMax(boards, b, Math.min(6, count), -Infinity, Infinity, false);
                        }else{
                            console.log("ULTRA DEEP SEARCH");
                            savedMm = miniMax(boards, b, Math.min(7, count), -Infinity, Infinity, false);
                        }
                        console.log(savedMm);
                        var score2 = savedMm.mE;
                        boards[currentBoard][b] = 0;
                        bestScore[b] += score2;
                        //boardSel[b] = savedMm.tP;
                        //console.log(score2);
                    }
                }
            }

            console.log(bestScore);

            //Choses to play on the square with the highest evaluation in the bestScore array
            for(var i in bestScore){
                if(bestScore[i] > bestScore[bestMove]){
                    bestMove = i;
                }
            }

            //Actually places the cross/nought
            if(boards[currentBoard][bestMove] === 0){
                boards[currentBoard][bestMove] = ai;
                currentBoard = bestMove;
            }

            console.log(evaluateGame(boards, currentBoard));
        }

        //document.getElementById("loader").setAttribute('hidden', 'hidden');

        currentTurn = -currentTurn;

    }

    shapeSize = squareSize/6;

    //mouseClickHandler
    if(clicked === true && gameRunning) {
        for (var i in boards) {
            if(currentBoard !== -1){i = currentBoard;if(mainBoard[currentBoard] !== 0){continue;}}
            for (var j in boards[i]) {
                if(boards[i][j] === 0) {
                    if (mousePosX > (WIDTH / 3 - squareSize) / 2 + squareSize / 6 - shapeSize + (j % 3) * squareSize / 3 + (i % 3) * WIDTH / 3 && mousePosX < (WIDTH / 3 - squareSize) / 2 + squareSize / 6 + shapeSize + (j % 3) * squareSize / 3 + (i % 3) * WIDTH / 3) {
                        if (mousePosY > (WIDTH / 3 - squareSize) / 2 + squareSize / 6 - shapeSize + Math.floor(j / 3) * squareSize / 3 + Math.floor(i / 3) * WIDTH / 3 && mousePosY < (WIDTH / 3 - squareSize) / 2 + squareSize / 6 + shapeSize + Math.floor(j / 3) * squareSize / 3 + Math.floor(i / 3) * WIDTH / 3) {
                            boards[i][j] = currentTurn;
                            currentBoard = j;
                            currentTurn = -currentTurn;
                            MOVES++;
                            break;
                        }
                    }
                }
            }
        }
    }

    //DRAW BOARDS

    squareSize = WIDTH/4;
    var shapeSize = WIDTH/36;

    ctx.strokeStyle = COLORS.black;
    ctx.lineWidth = 3;
    ctx.beginPath();
    ctx.moveTo(WIDTH/3, 0);
    ctx.lineTo(WIDTH/3, WIDTH);
    ctx.stroke();

    ctx.beginPath();
    ctx.moveTo(WIDTH/3*2, 0);
    ctx.lineTo(WIDTH/3*2, WIDTH);
    ctx.stroke();

    ctx.beginPath();
    ctx.moveTo(0, WIDTH/3);
    ctx.lineTo(WIDTH, WIDTH/3);
    ctx.stroke();

    ctx.beginPath();
    ctx.moveTo(0, WIDTH/3*2);
    ctx.lineTo(WIDTH, WIDTH/3*2);
    ctx.stroke();

    ctx.lineWidth = 3;
    for(var i = 0; i < 3; i++){
        for(var j = 0; j < 3; j++){
            ctx.beginPath();
            ctx.moveTo(i*WIDTH/3 + (WIDTH/3-squareSize)/2 + squareSize/3, j*WIDTH/3 + (WIDTH/3 - squareSize)/2);
            ctx.lineTo(i*WIDTH/3 + (WIDTH/3-squareSize)/2 + squareSize/3, j*WIDTH/3 + (WIDTH/3 - squareSize)/2 + squareSize);
            ctx.stroke();

            ctx.beginPath();
            ctx.moveTo(i*WIDTH/3 + (WIDTH/3-squareSize)/2 + squareSize*2/3, j*WIDTH/3 + (WIDTH/3 - squareSize)/2);
            ctx.lineTo(i*WIDTH/3 + (WIDTH/3-squareSize)/2 + squareSize*2/3, j*WIDTH/3 + (WIDTH/3 - squareSize)/2 + squareSize);
            ctx.stroke();

            ctx.beginPath();
            ctx.moveTo(i*WIDTH/3 + (WIDTH/3 - squareSize)/2, j*WIDTH/3 + (WIDTH/3-squareSize)/2 + squareSize/3);
            ctx.lineTo(i*WIDTH/3 + (WIDTH/3 - squareSize)/2 + squareSize, j*WIDTH/3 + (WIDTH/3-squareSize)/2 + squareSize/3);
            ctx.stroke();

            ctx.beginPath();
            ctx.moveTo(i*WIDTH/3 + (WIDTH/3 - squareSize)/2, j*WIDTH/3 + (WIDTH/3-squareSize)/2 + squareSize*2/3);
            ctx.lineTo(i*WIDTH/3 + (WIDTH/3 - squareSize)/2 + squareSize, j*WIDTH/3 + (WIDTH/3-squareSize)/2 + squareSize*2/3);
            ctx.stroke();
        }
    }

    //Draws the SMALL noughts and crosses
    ctx.lineWidth = 5;

    for(var i in boards){
        if(mainBoard[i] === 0) {
            if (checkWinCondition(boards[i]) !== 0) {
                mainBoard[i] = checkWinCondition(boards[i]);
            }
        }
        for(var j in boards[i]){
            if(boards[i][j] === 1*switchAroo){
                ctx.strokeStyle = COLORS.red;
                ctx.beginPath();
                ctx.moveTo((WIDTH/3-squareSize)/2 + squareSize/6 - shapeSize + (j%3)*squareSize/3 + (i%3)*WIDTH/3, (WIDTH/3 - squareSize)/2 + squareSize/6 - shapeSize + Math.floor(j/3)*squareSize/3 + Math.floor(i/3)*WIDTH/3);
                ctx.lineTo((WIDTH/3-squareSize)/2 + squareSize/6 + shapeSize + (j%3)*squareSize/3 + (i%3)*WIDTH/3, (WIDTH/3 - squareSize)/2 + squareSize/6 + shapeSize + Math.floor(j/3)*squareSize/3 + Math.floor(i/3)*WIDTH/3);
                ctx.stroke();

                ctx.beginPath();
                ctx.moveTo((WIDTH/3-squareSize)/2 + squareSize/6 - shapeSize + (j%3)*squareSize/3 + (i%3)*WIDTH/3, (WIDTH/3 - squareSize)/2 + squareSize/6 + shapeSize + Math.floor(j/3)*squareSize/3 + Math.floor(i/3)*WIDTH/3);
                ctx.lineTo((WIDTH/3-squareSize)/2 + squareSize/6 + shapeSize + (j%3)*squareSize/3 + (i%3)*WIDTH/3, (WIDTH/3 - squareSize)/2 + squareSize/6 - shapeSize + Math.floor(j/3)*squareSize/3 + Math.floor(i/3)*WIDTH/3);
                ctx.stroke();
            }else if(boards[i][j] === -1*switchAroo){
                ctx.strokeStyle = COLORS.blue;
                ctx.beginPath();
                ctx.ellipse((WIDTH/3-squareSize)/2 + squareSize/6 + (j%3)*squareSize/3 + (i%3)*WIDTH/3, (WIDTH/3 - squareSize)/2 + squareSize/6 + Math.floor(j/3)*squareSize/3 + Math.floor(i/3)*WIDTH/3, shapeSize*1.1, shapeSize*1.1, 0, 0, Math.PI*2);
                ctx.stroke();
            }
        }
    }

    //Checks the win conditions
    if(gameRunning){
        if (checkWinCondition(mainBoard) !== 0) {
            gameRunning = false;
            document.getElementById("winMenu").removeAttribute("hidden");
            if(checkWinCondition(mainBoard) === 1){
                document.getElementById("result").innerHTML = playerNames[0] + " WINS!";
            }else{
                document.getElementById("result").innerHTML = playerNames[1] + " WINS!";
            }
        }

        //Once again, count the amount of playable squares, if it's 0, game is a tie
        var countw = 0;
        for(var bt = 0; bt < boards.length; bt++){
            if(checkWinCondition(boards[bt]) === 0){
                boards[bt].forEach((v) => (v === 0 && countw++));
            }
        }

        if(countw === 0){
            gameRunning = false;
            document.getElementById("winMenu").removeAttribute("hidden");
            document.getElementById("result").innerHTML = "IT'S A TIE!";
        }
    }

    shapeSize = squareSize/3;
    ctx.lineWidth = 20;

    //Draws the BIG noughts and crosses
    for(var j in mainBoard){
        if(mainBoard[j] === 1*switchAroo){
            ctx.strokeStyle = COLORS.red;
            ctx.beginPath();
            ctx.moveTo(WIDTH/6 - shapeSize + (j%3)*WIDTH/3, WIDTH/6 - shapeSize + Math.floor(j/3)*WIDTH/3);
            ctx.lineTo(WIDTH/6 + shapeSize + (j%3)*WIDTH/3, WIDTH/6 + shapeSize + Math.floor(j/3)*WIDTH/3);
            ctx.stroke();

            ctx.beginPath();
            ctx.moveTo(WIDTH/6 - shapeSize + (j%3)*WIDTH/3, WIDTH/6 + shapeSize + Math.floor(j/3)*WIDTH/3);
            ctx.lineTo(WIDTH/6 + shapeSize + (j%3)*WIDTH/3, WIDTH/6 - shapeSize + Math.floor(j/3)*WIDTH/3);
            ctx.stroke();
        }else if(mainBoard[j] === -1*switchAroo){
            ctx.strokeStyle = COLORS.blue;
            ctx.beginPath();
            ctx.ellipse(WIDTH/6 + (j%3)*WIDTH/3, WIDTH/6 + Math.floor(j/3)*WIDTH/3, shapeSize*1.1, shapeSize*1.1, 0, 0, Math.PI*2);
            ctx.stroke();
        }
    }

    if(mainBoard[currentBoard] !== 0 || !boards[currentBoard].includes(0)){currentBoard = -1;}

    //HIGHLIGHT BOARD TO PLAY ON

    ctx.fillStyle = COLORS.red;
    ctx.globalAlpha = 0.1;
    ctx.fillRect(WIDTH/3*(currentBoard%3), WIDTH/3*Math.floor(currentBoard/3), WIDTH/3, WIDTH/3);
    ctx.globalAlpha = 1;

    //Draw EVAL BAR

    ctx.globalAlpha = 0.9;
    if(evaluateGame(boards, currentBoard)*switchAroo > 0){
        ctx.fillStyle = COLORS.blue;
    }else{
        ctx.fillStyle = COLORS.red;
    }
    ctx.fillRect(WIDTH/2, WIDTH, evaluateGame(boards, currentBoard)*2*switchAroo, HEIGHT/16);
    ctx.globalAlpha = 1;

    ctx.strokeStyle = 'black';
    ctx.lineWidth = 4;

    ctx.beginPath();
    ctx.moveTo(WIDTH/2, WIDTH);
    ctx.lineTo(WIDTH/2, WIDTH+HEIGHT);
    ctx.stroke();

    //console.log(RUNS);

    if(AIACTIVE){
        ctx.globalAlpha = 0.3;
        ctx.fillStyle = COLORS.black;
        ctx.fillRect(WIDTH/2, WIDTH, bestScore[bestMove]*2*switchAroo, HEIGHT/16);
        ctx.globalAlpha = 1;
    }

    clicked = false;

}
