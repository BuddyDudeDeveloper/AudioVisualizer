//The core shape of the sketch. Composed of curved vertexes and a circle.
class Deformer implements Drawable {

  //The radius of the inner circle.
  private final int INNER_RADIUS = width/3;
  
  //The radius of the inner circle.
  private final float OUTER_RADIUS = width/5;
  
  //The current position of the deformer.
  private final PVector _position = new PVector(width/2, height/2);
  
  //The points in the outer deforming circle.
  private final ArrayList<Point> _points = new ArrayList<Point>();
  
  //The points selected to be deformed by the audio data.
  private ArrayList<Point> _randomPoints;
  
  //The amount of points that form the deforming circle.
  private final int LEVEL_OF_DETAIL = 50;
  
  //The scale of the outer circle.
  private float _scale = 1;
  
  //The scale of the inner circle.
  private float _innerScale = 1;
  
  //The flag for whether or not the song has hit a beat.
  private boolean _isOnset;
  
  //The text displaying the artist of the song.
  private Text _author = new Text();
  
  //The text displaying the name of the song.
  private Text _title = new Text();

  //Class constructor.
  Deformer() {
    
    //Allocates the memory for and sets up deforming points.
    setupOuterDeformingPoints();
    
    //Sets up the song information text.
    setupText();
  }

  //Sets up the song information text.
  private void setupText() {
    
    //Fetches the name of the song from the Audio manager class.
    String author = Audio.getAuthor();
    
    //Fetches the name of the artist from the Audio manager class.
    String title = Audio.getTitle();
    
    //If there is no artist, the user is informed.
    _author.setValue(author.isEmpty() ? "Unknown Artist" : author);
    
    //Positions the text 50 pixels above the center of the sketch.
    _author.setPosition(new PVector(0, 50));
    
    //If there is no title, the user is informed.
    _title.setValue(title.isEmpty() ? "Unknown Song" : title);
    
    //Positions the text 50 pixels below the center of the sketch.
    _title.setPosition(new PVector(0, -50));
    
    //Sets the font size of the title to be bigger than the default.
    _title.setSize(32);
  }

  //Allocates memory for and sets up deforming points.
  void setupOuterDeformingPoints() {
    
    //For each level of detail...
    for (int i = 0; i < LEVEL_OF_DETAIL; i++) {
      
      //Create a new deforming point.
      Point point = new Point();
      
      //Calculates the angle to be a fraction of the whole circle.
      float angle = i * (TAU / LEVEL_OF_DETAIL);
      
      //Set the position of that point based on the radius of the circle.
      point.setPosition(new PVector(OUTER_RADIUS * cos(angle), OUTER_RADIUS * sin(angle)));
      
      //Sets the point's angle.
      point.setAngle(angle);
      
      //Adds the point to the collection of points.
      _points.add(point);
    }
  }

  //Displays the shape and text and updates them once per frame (240 times per second).
  public void draw() {
    
    //Fetches whether or not the song is on beat.
    _isOnset = Audio.getIsOnset();
    
    //BEGIN MATRIX
    pushMatrix();
    
    //Moves the shape to the desired location.
    translate(_position.x, _position.y);
    
    //Scales the size of the shape.
    scale(_scale);
    
    //Displays the shape formed from the deforming points.
    drawDeformingCircle();
    
    //Draws the center circle with the artist and title text.
    drawCenterCircleWithText();
    
    //Updates the scale values.
    updateScaling();
    
    //END MATRIX
    popMatrix();
  }

  //Displays the artist and song title text.
  private void drawText() {
    
    //Fetches the name of the song from the Audio manager class.
    String author = Audio.getAuthor();
    
    //Fetches the name of the artist from the Audio manager class.
    String title = Audio.getTitle();
    
    //If there is no artist, the user is informed.
    _author.setValue(author.isEmpty() ? "Unknown Artist" : author);
    
    //If there is no title, the user is informed.
    _title.setValue(title.isEmpty() ? "Unknown Song" : title);
    
    //Displaus the artist's name.
    _author.draw();
    
    //Displays the title of the song.
    _title.draw();
  }

  //Updates the scale values and sets their minimums.
  public void updateScaling() {
    
    //If the outer scale is greater than 1, scale it down. Otherwise, limit the scale to 1.
    if (_scale > 1) _scale *= .99;
    else _scale = 1;
    
    //If the inner scale is greater than 1, scale it down. Otherwise, limit the scale to 1.
    if (_innerScale > 1) _innerScale *= .999;
    else _innerScale = 1;

    //When on beat...
    if (_isOnset) {
      
      //Sets the inner scale based on half the audio level.
      _innerScale = 1 + Audio.getLevel()/2;
      
      //Sets the outer scale based on the audio level.
      _scale = 1 + Audio.getLevel();
    }
  }

  //Displays the inner circle and informational text.
  private void drawCenterCircleWithText() {
    
    //Sets the stroke weight to 10.
    strokeWeight(10);
    
    //BEGIN MATRIX
    pushMatrix();
    
    //Scales inner circle by determined amount.
    scale(_innerScale);
    
    //Fills that circle with the same color as the background, making it appear cut-out.
    fill(Colors.getBackgroundColor());
    
    //Draws the circle with a smaller radius than the outer circle.
    circle(0, 0, INNER_RADIUS);
    
    //Displays the informational text.
    drawText();
    
    //END MATRIX
    popMatrix();
  }

  //Displays the deformed points as a circle and deforms random points.
  private void drawDeformingCircle() {
    
    stroke(Colors.getBackgroundColor());
    strokeWeight(1);
    
    //BEGIN SHAPE
    beginShape();
    
    //If the song is on beat...
    if (_isOnset) {
      
      //Select random points on the updated circle.
      chooseRandomPoints();
      
      //Update their position based on the audio data.
      updateRandomPointPositions();
    }
    
    //Display all points on the deformed circle.
    drawPoints();
    
    //END SHAPE
    endShape(CLOSE);
    
    noStroke();
  }
  
  //Display all points on the deformed circle.
  private void drawPoints() {
    
    //For each point in the collection of points...
    for (Point point : _points) {
      
      //If the point was selected to be deformed...
      if (point.getExtraDistance() > 0) {
        
        //Fetch the extra distance.
        int extraDistance = point.getExtraDistance();
        
        //Fetch the angle of the point relative to the center of the circle.
        float angle = point.getAngle();
        
        //Add the additional distance to the point's location on the circle.
        float radius = OUTER_RADIUS + extraDistance;
        
        //Set the position based on the extra distance applied.
        point.setPosition(new PVector(radius * cos(angle), radius * sin(angle)));
      }
      
      //Display the point.
      point.draw();
    }
  }

  //Calculates the extra distance a point will move based on the audio data.
  private void updateRandomPointPositions() {
    
    //For each random point in the list of random points.
    for (Point randomPoint : _randomPoints) {
      
      //Calculate the extra distance based on the audio level. Range is randomized for a more dynamic effect.
      randomPoint.setExtraDistance((int)random(map(Audio.getIntensity(), -50, 50, 10, 100) * Audio.getLevel(), map(Audio.getIntensity(), -50, 50, 100, 1000) * Audio.getLevel()));
      
      //Fetch the extra distance.
      int extraDistance = randomPoint.getExtraDistance();
      
      //Fetch the point's angle relative to the center of the circle.
      float angle = randomPoint.getAngle();
      
      //Add the additional distance to the point's location on the circle.
      float radius = OUTER_RADIUS + extraDistance;
      
      //Set the position based on the extra distance applied.
      randomPoint.setPosition(new PVector(radius * cos(angle), radius * sin(angle)));
    }
  }

  //Selects the points to be deformed.
  private void chooseRandomPoints() {
    
    //Calculates the number of affected points. It can be any number between 1 and 1/4 of the total points.
    int numberOfRandomPoints = (int)random(1, LEVEL_OF_DETAIL/4);
    
    //Create a collection of random points to be added to.
    ArrayList<Point> randomPoints = new ArrayList<Point>();
    
    //For each number of random points to be deformed...
    for (int i = 0; i < numberOfRandomPoints; i++) {
      
      //Get a random point from the collection of points.
      Point point = _points.get((int)random(1, LEVEL_OF_DETAIL));
      
      //If that point has not already been selected to be deformed, then add it to the list of be deformed.
      if (!randomPoints.contains(point)) randomPoints.add(point);
    }
    
    //Updates the list of random points.
    _randomPoints = randomPoints;
  }
}
