//Background rectangle for additional effects.
class DeformingBar implements Drawable {

  //The location of the bar in the sketch.
  private final PVector _position = new PVector();

  //The lowest height of the box.
  private final int MINIMUM_HEIGHT = 50;

  //The size of the bar.
  private final PVector _size = new PVector(25, MINIMUM_HEIGHT);

  //The amount of interpolation between the fill colors.
  private float _lerp;

  //The location of the bar in the collection of bars.
  private int _index;
  
  //The lowest index that can affect the intensity.
  private int _minimumInfluencedIndex;
  
  //The lowest index that can affect the intensity.
  private int _maximumInfluencedIndex;

  //Class constructor.
  DeformingBar() {
    _size.x = width / _size.x;
  }

  //Displays the bars.
  public void draw() {

    //BEGIN MATRIX
    pushMatrix();

    //Move the bar to its position.
    translate(_position.x, _position.y);

    //No fill, stroke is accent color.
    fill(lerpColor(Colors.getBackgroundColor(), Colors.getAccentColor(), _lerp));
    stroke(Colors.getAccentColor());

    //Draws the shape with a corner radius of 1.
    rect(0, 0, _size.x, _size.y, 1);

    //END MATRIX;
    popMatrix();

    //Changes the height of the bar if one beat.
    driveHeightWithBeat();

    //If the height has been changed, it will be faded back to normal.
    fadeHeight();
  }

  //Returns the height to its original number.
  private void fadeHeight() {
    if (_size.y > MINIMUM_HEIGHT) _size.y *= .99;
    else if (_size.y < MINIMUM_HEIGHT) _size.y = MINIMUM_HEIGHT;
    if (_lerp > 0) _lerp *= .95;
    else _lerp = 0;
  }

  //If the song is on beat, set the height of the bar varied based on the intensity level set up the user and the audio level.
  private void driveHeightWithBeat() {
    if (Audio.getIsOnset()) {
        boolean inRange = _index > _minimumInfluencedIndex && _index < _maximumInfluencedIndex;
        _size.y = MINIMUM_HEIGHT + random(map(Audio.getIntensity(), -50, 50, inRange ? 500 : 100, inRange ? 1000 : 500) * Audio.getLevel(), map(Audio.getIntensity(), -50, 50, inRange ? 1000 : 500, inRange ? 2500 : 1000) * Audio.getLevel());
        _lerp = 1;
    }
  }

  //Setter for the point's position.
  public void setPosition(PVector value) {
    _position.set(value);
  }

  //Setter for the location of the bar in the collection of bars.
  public void setIndex(int value) {
    _index = value;
  }
  
  //The lowest index that can affect the intensity.
  public void setMinimumInfluencedIndex(int value) {
    _minimumInfluencedIndex = value;
  }

  //The lowest index that can affect the intensity.
  public void setMaximumInfluencedIndex(int value) {
    _maximumInfluencedIndex = value;
  }
}
