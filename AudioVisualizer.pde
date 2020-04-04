//All necessary imports for the audio library.
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

//The shape driven by audio data.
private Deformer _deformer;

//The visual indicator for playing and pausing the song.
private Key _play;

//The visual indicator for increasing the volume of the song.
private Key _intensityUp;

//The visual indicator for decreasing the volume of the song.
private Key _intensityDown;

//The visual indicator for loading a new song.
private Key _shuffle;

//The visual indicator for changing to the next color.
private Key _colorUp;

//The visual indicator for changing to the previous color.1
private Key _colorDown;

//A flag for if the song was loaded.
private boolean _songLoaded;

//A visual indicator of the volume percentage.
private InformationBar _volume;

//A visual controller for the directionality of the audio.
private PanControl _panControl;

//The size of the sketch on the previous frame;
private PVector _previousSketchSize = new PVector();

//A group of the background bars being deformed.
private ArrayList<DeformingBar> _bars;

//A visual indicator of the intensity percentage.
private InformationBar _intensity;

//The lowest index of deforming bars.
private int _minimumIndex;

//The highest index of deforming bars.
private int _maximumIndex;

//Informative text that tells the user they need to load a song.
private Text _loadPrompt = new Text();

//Processing's function called at the beginning of the sketch.
void setup() {

  /*
    The following are properties of the sketch:
   - 960x540 using P2D renderer.
   - The sketch runs at 240hz, the highest refresh rate available on any monitor on the market.
   - Text and rectangles draw from their center.
   */
  size(960, 540, P2D);
  frameRate(240);
  textAlign(CENTER);
  rectMode(CENTER);

  //Checks the data folder for songs to load.
  _songLoaded = checkForSongs();

  //Updates the sketch size container with the starting size of the sketch.
  _previousSketchSize.set(new PVector(width, height));

  //If no song is loaded...
  if (!_songLoaded) {
    //Intialize the loading prompt.
    _loadPrompt.setValue("Add songs to the data folder, then press ENTER.");
    _loadPrompt.setSize(32);
    _loadPrompt.setCharacterLimit(100);
    _loadPrompt.setPosition(new PVector(width/2, height/2));
  }
}

//Processing's function called once per frame (240fps).
void draw() {

  //Redraws the background every frame to prevent paint effect.
  background(Colors.getBackgroundColor());

  //Once the song has been successfully loaded...
  if (_songLoaded) {

    //Update the audio and beat detection.
    Audio.draw();

    //Uses the audio pan to determine which bars should be influenced more. The left bars are influenced more when the pan is set to the left and visa versa.
    float pan = Audio.getPan();
    _minimumIndex = (int)map(pan, -1, 1, 0, _bars.size()/2);
    _maximumIndex = (int)map(pan, -1, 1, _bars.size()/2, _bars.size());


    //For each deforming bar...
    for (DeformingBar bar : _bars) {

      //Update the influenced indicies and display them,
      bar.setMinimumInfluencedIndex(_minimumIndex);
      bar.setMaximumInfluencedIndex(_maximumIndex);
      bar.draw();
    }

    //Draw the shape that is deformed by the audio data.
    _deformer.draw();

    //Display the visual indicators for the keys.
    drawKeys();

    //Display the volume indicator.
    _volume.draw();

    //Display the pan controller.
    _panControl.draw();

    //Display the intensity indicator.
    _intensity.draw();

    //If there are no songs in the queue...
  } else {

    //Only display the loading prompt.
    _loadPrompt.draw();
  }

  //If the size of the sketch on the previous frame is not the same as the current size of the sketch, then a resizing of the window has occured and the visual elements need to be moved accordingly.
  if (!_previousSketchSize.equals(new PVector(width, height))) resize();

  //Updates the sketch size container with the starting size of the sketch.
  _previousSketchSize.set(width, height);
}

//Handles the resizing of the sketch.
private void resize() {

  //If the song is loaded...
  if (_songLoaded) {

    //Resets the deformer.
    _deformer = new Deformer();

    //Resets the volume bar.
    _volume = new InformationBar();
    _volume.update(Audio.getVolume());

    //Resets the keys.
    setupKeys();

    //Resets the bars.
    setupBars();
  }

  //Relocates the load prompt to the center.
  _loadPrompt.setPosition(new PVector(width/2, height/2));
}

//Processing's function called when a key is released.
void keyReleased() {

  //If the space key is pressed...
  if (keyCode == 32) {

    //Changes the pause/play text depending on if the song is playing.
    _play.setText("Space", Audio.getIsPlaying() ? "Play" : "Pause");

    //Changes the play/pause state to the opposite state.
    Audio.toggle();
  } else {

    //If the following keys are pressed.
    switch(key) {

      //If the + key is pressed...
    case '+':

      //Increase the intensity and update the indictator.
      Audio.changeIntensity(true);
      _intensity.update(Audio.getIntensity());

      break;

      //If the - key is pressed...
    case '-':

      //Decrease the intensity and update the indictator.
      Audio.changeIntensity(false);
      _intensity.update(Audio.getIntensity());

      break;

      //if the s key is pressed...
    case 's':

      //Shuffle the audio.
      Audio.shuffle();
      
      //Displays the opposite state of the shuffle.
      _shuffle.setText("S", Audio.getUnshuffled() ? "Shuffle" : "Order");
      break;

      //If the ] key is pressed...
    case ']':

      //Change the color.
      Colors.changeColors(true);
      
      //If the indicators exist...
      if (_colorUp != null && _colorDown != null) {
        
        //Set their text based on the previous and upcoming colors.
        _colorUp.setText("]", determineColorName(true));
        _colorDown.setText("[", determineColorName(false));
      }
      break;

    //If the [ key is pressed...
    case '[':
    
      //Change the color.
      Colors.changeColors(false);
      
      //If the indicators exist...
      if (_colorUp != null && _colorDown != null) {
        
        //Set their text based on the previous and upcoming colors.
        _colorUp.setText("]", determineColorName(true));
        _colorDown.setText("[", determineColorName(false));
      }
      break;
      
      //If the enter key is pressed...
    case ENTER:
      
      //Verify that there are songs in the data directory.
      _songLoaded = checkForSongs();
      
      //If there are none...
      if (!_songLoaded) {
        
        //Inform the user of the error and how to resolve it.
        _loadPrompt.setValue("ERROR: No playable files.\nPlease add .mp3 files to the data folder, then hit ENTER.");
      }
      break;
    }
  }
}

//Processing function for when a mouse button is clicked.
void mousePressed() {
  
  //If a song has been loaded...
  if (_songLoaded) {
      //Checks if the pan controller has been clicked on.
    _panControl.setClickedOn(_panControl.isOverlapping());
    
    //If the play button is clicked on...
    if (_play.mouseIsOverlapping()) {
      
      //Changes the pause/play text depending on if the song is playing.
      _play.setText("Space", Audio.getIsPlaying() ? "Play" : "Pause");

      //Changes the play/pause state to the opposite state.
      Audio.toggle();
    } 
    
    //If the intensity up button is clicked on...
    else if (_intensityUp.mouseIsOverlapping()) {
      
      //Increase the intensity and update the indictator.
      Audio.changeIntensity(true);
      
      //Update the intensity visuals.
      _intensity.update(Audio.getIntensity());
      
    } 
    
    //If the intensity down button was clicked...
    else if (_intensityDown.mouseIsOverlapping()) {
      
      //Increase the intensity and update the indictator.
      Audio.changeIntensity(false);
      
      //Update the intensity visuals.
      _intensity.update(Audio.getIntensity());
    } 
    
    //If the shuffle button was clicked...
    else if (_shuffle.mouseIsOverlapping()) {
      
      //Shuffle the audio.
      Audio.shuffle();
      
      //Set the text of the indicator to reflect the state of the next press.
      _shuffle.setText("S", Audio.getUnshuffled() ? "Shuffle" : "Order");
    } 
    
    //If the color up button is clicked...
    else if (_colorUp.mouseIsOverlapping()) {
      
      //Change the color.
      Colors.changeColors(true);
      
      //If the indicators exist...
      if (_colorUp != null && _colorDown != null) {
        
        //Set their text based on the previous and upcoming colors.
        _colorUp.setText("]", determineColorName(true));
        _colorDown.setText("[", determineColorName(false));
      }
    } 
    
    //If the color down button is clicked...
    else if (_colorDown.mouseIsOverlapping()) {
      
     //Change the color.
      Colors.changeColors(false);
      
      //If the indicators exist...
      if (_colorUp != null && _colorDown != null) {
        
        //Set their text based on the previous and upcoming colors.
        _colorUp.setText("]", determineColorName(true));
        _colorDown.setText("[", determineColorName(false));
      }
    }
  }
}

//Processing function for when a mouse button is released.
void mouseReleased() {
  //Marks the pan controller as not being clicked on.
  if (_songLoaded) _panControl.setClickedOn(false);
}

//Processing function called when the mouse wheel is rotated.
void mouseWheel(MouseEvent event) {

  //Update the audio player's volume and update the indicator.
  Audio.changeVolume(false, event.getCount());
  _volume.update(Audio.getVolume());
}

//Allocates memory for and sets up display elements of possible keyboard inputs.
private void setupKeys() {

  //The vertical location of every key.
  int keyY = height - 40;

  //The Space Bar for playing/pausing the song.
  _play = new Key();
  _play.setSize(new PVector(100, 25));
  _play.setPosition(new PVector(width - 60, keyY));
  _play.setText("Space", "Pause");

  //The + key for increasing to volume.
  _intensityUp = new Key();
  _intensityUp.setPosition(new PVector(width - 180, keyY));
  _intensityUp.setText("+", "Up");

  //The - key for decreasing the volume.
  _intensityDown = new Key();
  _intensityDown.setPosition(new PVector(width - 145, keyY));
  _intensityDown.setText("-", "Down");

  //The N key for loading a new song.
  _shuffle = new Key();
  _shuffle.setPosition(new PVector(width - 225, keyY));
  _shuffle.setText("S", "Shuffle");

  //The controller for the direction of the audio.
  _panControl = new PanControl();
  _panControl.setPosition(new PVector(width - 270, keyY));

  //The visual indicator for the intensity of the effects.
  _intensity = new InformationBar();
  _intensity.setPosition(new PVector(width - 50, 50));
  _intensity.setLabel("Intensity");
  _intensity.update(Audio.getIntensity());

  //The visual indicator to advance the color scheme.
  _colorUp = new Key();
  _colorUp.setPosition(new PVector(width - 315, keyY));
  _colorUp.setText("]", determineColorName(true));

  //The visual indicator to return to the previous color scheme.
  _colorDown = new Key();
  _colorDown.setPosition(new PVector(width - 350, keyY));
  _colorDown.setText("[", determineColorName(false));
}

//Chooses the acronyms of the colors based on the current background color.
//boolean forward is used to determine if it is the next color or not.
private String determineColorName(boolean forward) {
  switch(Colors.getBackgroundColor()) {
      case Colors.DARK_BLUE:
    return forward ? "DG" : "LG";
  case Colors.DARK_GREEN:
    return forward ? "DO" : "DB";
  case Colors.DARK_ORANGE:
    return forward ? "LB" : "DG";
  case Colors.LIGHT_BLUE:
    return forward ? "LG" : "DO";
  case Colors.LIGHT_GREEN:
    return forward ? "LB" : "LO";
  case Colors.LIGHT_ORANGE:
    return forward ? "LG" : "DB";
  default:
    return "";
  }
}

//Draws all the visual input indicators.
private void drawKeys() {

  //Displays the space bar.
  _play.draw();

  //Displays the + key.
  _intensityUp.draw();

  //Displays the - key.
  _intensityDown.draw();

  //Displays the N key.
  _shuffle.draw();

  //Displays the ] key.
  _colorUp.draw();

  //Displays the [ key.
  _colorDown.draw();
}

//Allocates memory for the background bars.
private void setupBars() {

  //Reset the collection.
  _bars = new ArrayList<DeformingBar>();

  //The position of the bar in the array.
  int index = 0;

  //Spanning the width...
  for (float i = 0; i < width; i += width/25) {

    //Create a new bar.
    DeformingBar bar = new DeformingBar();

    //Set its position.
    bar.setPosition(new PVector(i, height/2));

    //The bar stores information about its index.
    bar.setIndex(index);

    //Add it to the collection.
    _bars.add(bar);

    //Increment the index.
    index++;
  }
}


//Checks whether or not there are songs in the data directory.
private boolean checkForSongs() {

  //If an audio file was successfully loaded.
  if (Audio.setup(this)) {

    //Creates the shape to be deformed by the audio.
    _deformer = new Deformer();

    //Sets up the visual input indicators.
    setupKeys();

    //Sets up background audio-driven rectangles.
    setupBars();

    //Sets up the volume visual indictator.
    _volume = new InformationBar();
    _volume.update(Audio.getVolume());

    //Flags that the song has been loaded.
    return true;
  }

  //Flags that the song was not loaded.
  return false;
}
