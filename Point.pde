//The points of the deforming shape.
class Point implements Drawable {
  
  //The location of the point in the sketch.
  private final PVector _position = new PVector();
  
  //The distance the point is from its original location on the circle.
  private int _extraDistance = 0;
  
  //The speed at which fading values fade.
  private final float SPEED = .99;
  
  //The angle of the point relative to the center of the circle.
  private float _angle = 0;
  
  
  //Displays the shape.
  public void draw() {
    
    //Fill the points with the accent color.
    fill(Colors.getAccentColor());
    
    //Place a curved vertex at the desired position.
    curveVertex(_position.x, _position.y);
    
    //If the extra distance is higher than the lowest possible value, then fade it out until it hits that value.
    if(_extraDistance > 0) {
      _extraDistance *= SPEED;
    }
    else _extraDistance = 0;
  }
  
  //Setter for the point's position.
  public void setPosition(PVector value) {
    _position.set(value);
  }
  
  //Setter for the extra distance beyond the traditional radius of the circle.
  public void setExtraDistance(int value) {
    _extraDistance = value;
  }
  
  //Getter for the extra distance beyond the traditional radius of the circle.
  public int getExtraDistance() {
    return _extraDistance;
  }
  
  //Getter for the angle of the point relative to the center of the circle.
  public float getAngle() {
    return _angle;
  }
  
  //Getter for the angle of the point relative to the center of the circle.
  public void setAngle(float value) {
    _angle = value;
  }
}
