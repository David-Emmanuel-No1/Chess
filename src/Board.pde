class Board {
  Piece[][] pieces;
  Tuple first, last;
  char player;

  Board() {
    player = 'w';
    pieces = new Piece[8][8];

    pieces[0][0] = new Piece("bR");
    pieces[0][1] = new Piece("bN");
    pieces[0][2] = new Piece("bB");
    pieces[0][3] = new Piece("bQ");
    pieces[0][4] = new Piece("bK");
    pieces[0][5] = new Piece("bB");
    pieces[0][6] = new Piece("bN");
    pieces[0][7] = new Piece("bR");

    pieces[1][0] = new Piece("bP");
    pieces[1][1] = new Piece("bP");
    pieces[1][2] = new Piece("bP");
    pieces[1][3] = new Piece("bP");
    pieces[1][4] = new Piece("bP");
    pieces[1][5] = new Piece("bP");
    pieces[1][6] = new Piece("bP");
    pieces[1][7] = new Piece("bP");

    pieces[6][0] = new Piece("wP");
    pieces[6][1] = new Piece("wP");
    pieces[6][2] = new Piece("wP");
    pieces[6][3] = new Piece("wP");
    pieces[6][4] = new Piece("wP");
    pieces[6][5] = new Piece("wP");
    pieces[6][6] = new Piece("wP");
    pieces[6][7] = new Piece("wP");

    pieces[7][0] = new Piece("wR");
    pieces[7][1] = new Piece("wN");
    pieces[7][2] = new Piece("wB");
    pieces[7][3] = new Piece("wQ");
    pieces[7][4] = new Piece("wK");
    pieces[7][5] = new Piece("wB");
    pieces[7][6] = new Piece("wN");
    pieces[7][7] = new Piece("wR");
  }

  void update(float x, float y) {
    if (first == null) {
      first = new Tuple(y/w, x/w);
      Piece p = pieces[first.i][first.j];
      if (p == null) {
        first = null;
      } else if (pieces[first.i][first.j].colr != player) {
        first = null;
      }
    } else if (last == null) {
      last = new Tuple(y/w, x/w);
      if (valid()) {
        pieces[last.i][last.j] = pieces[first.i][first.j];
        pieces[first.i][first.j] = null;
        player = player=='w'?'b':'w';
      } else {
        first = null;
        last = null;
        update(x,y);
      }
    } else {
      first = null;
      last = null;
      update(x,y);
    }
  }

  boolean valid() {
    Piece firstPiece = pieces[first.i][first.j];
    Piece lastPiece = pieces[last.i][last.j];
    
    boolean possible = (lastPiece == null) ||
      (firstPiece.colr != lastPiece.colr);
    if (possible) {
      if (checkMove()) {
        return !jump();
      }
    } else {
      return false;
    }
  }
  
  boolean checkMove() {
    Piece firstPiece = pieces[first.i][first.j];
    Piece lastPiece = pieces[last.i][last.j];
    
    int dx = last.j - first.j;
    int dy = last.i - first.i;
    
    char c = firstPiece.colr;
    
    if (firstPiece.type == 'K') {
      if (castling()) {
        return true;
      } else {
        return (dx>=-1 && dx<=1) && (dy>=-1 && dy<=1);
      }
    } else if (firstPiece.type == 'R') {
      return (dx==0 || dy==0);
    } else if (firstPiece.type == 'B') {
      return (abs(dx) == abs(dy));
    } else if (firstPiece.type == 'Q') {
      return (dx==0 || dy==0) || (abs(dx) == abs(dy));
    } else if (firstPiece.type == 'N') {
      return (abs(dx)==1 && abs(dy)==2) || (abs(dy)==1 && abs(dx)==2);
    } else if (firstPiece.type == 'P') {
      if ((dy>0&&c=='w')||(dy<0&&c=='b')) {
        return false;
      } else if (dx == 0) {
        if (lastPiece != null) {
          return false;
        } else if (abs(dy)==1) {
          return true;
        } else if (abs(dy) == 2) {
          int row = first.i;
          return (row==1) || (row==6);
        } else {
          return false;
        }
      } else if (abs(dx) == 1) {
        if (enPassant()) {
          return true;
        } else if (abs(dy) == 1) {
          if (lastPiece == null) {
            return false;
          } else {
            return firstPiece.colr != lastPiece.colr;
          }
        }
      } else {
        return false;
      }
    }
    
    return false;
  }
  
  boolean jump() {
    Piece firstPiece = pieces[first.i][first.j];
    Piece lastPiece = pieces[last.i][last.j];
    
    int dx = last.j - first.j;
    int dy = last.i - first.i;
    
    return false;
  }
  
  boolean castling() {
    return false;
  }
  
  boolean enPassant() {
    return false;
  }

  void show() {
    drawBoard();
    for (int i=0; i<8; i++) {
      for (int j=0; j<8; j++) {
        Piece p = pieces[i][j];
        if (p != null) {
          pieces[i][j].show(i, j);
        }
      }
    }
  }

  void drawBoard() {
    noStroke();
    color c = DARK;
    for (int i=0; i<8; i++) {
      if (c == LIGHT) {
        c = DARK;
      } else {
        c = LIGHT;
      }
      for (int j=0; j<8; j++) {
        fill(c);
        rect(j*w, i*w, w, w);
        if (c == LIGHT) {
          c = DARK;
        } else {
          c = LIGHT;
        }
      }
    }

    if (first != null) {
      fill(255, 255, 0);
      rect(first.j*w, first.i*w, w, w);
    }
    if (last != null) {
      fill(0, 255, 0);
      rect(last.j*w, last.i*w, w, w);
    }
  }
}
