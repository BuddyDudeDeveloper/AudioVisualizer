//A static manager class for the Minim library.
static class Audio {

  //A reference to the primary API.
  private static Minim _minim;

  //The controller of the audio playable.
  private static AudioPlayer _player;

  //The listener that relays beat data.
  private static BeatDetect _beat;

  //The buffer data of the audio file.
  private static AudioBuffer _mix;

  //The information about the audio file.
  private static AudioMetaData _data;

  //The loudness of the song.
  private static int _volume = 0;

  //The variation of the visual effects from the music.
  private static int _intensity = 0;

  //The flag for whether or not the user manually stopped the song.
  private static boolean _paused = false;

  //A list of the file paths to the audio tracks.
  private static ArrayList<String> _audioFiles = new ArrayList<String>();

  //The path to the data folder.
  private static File _dataFolder;

  //The number of the current song being played.
  private static int _currentSong = 0;
  
  //The order of the songs to be played.
  private static ArrayList<Integer> _order = new ArrayList<Integer>();
  
  //A reference to the application in memory.
  private static PApplet _app;
  
  //A flag for whether or not the tracks are shuffled.
  private static boolean _unshuffled = false;
  
  //Allocates the memory for all the Minim library classes used and sets up basic playback rules.
  //PApplet app is a reference to the application itself. Needed for Minim initalization.
  //String fileName is the name of the audio file to be loaded and played.
  public static boolean setup(PApplet app) {
    
    //Assigns the application pointer.
    _app = app;

    //Sets up the data path.
    _dataFolder = new File(app.sketchPath() + "\\data");
    
    //Updates the list of audio files in the data directory.
    updateAudioFiles();
    
    //If this is the first song, create the order.
    if(_currentSong == 0) shuffle();
    
    //If there are audio files...
    if(_audioFiles.size() > 0) {

      //Sets up pointers to all audio-related objects.
      _minim = new Minim(app);
  
      //Loads the file for playback and allocates memory for it.
      _player = _minim.loadFile(_audioFiles.get(_order.get(_currentSong % _order.size())), 2048);
  
      //Fetches the information about the audio track.
      _data = _player.getMetaData();
  
      //Gets the buffer of the audio file.
      _mix = _player.mix;
  
      //Creates object to find where beats happen.
      _beat = new BeatDetect();
  
      //Sets how many milliseconds between beats will be detected.
      _beat.setSensitivity(5);
  
      //Plays the song
      _player.play();
  
      //Flag that the song is not paused.
      _paused = false;
  
      //Because volume does not work on all platforms, gain is used to control the loudness.
      _player.setGain(_volume);
      
      return true;
    }
    
    //If the audio file is not loaded, flag it.
    else return false;
  }

  //Although this draw does not display anything, it updates the beat detection once per frame so the naming convention Processing uses was applied.
  public static void draw() {

    //Detects the song's beat using its audio buffer.
    _beat.detect(_mix);
    
    //Check for the end of the song.
    songEnded();
  }

  //Getter for if the song is on a beat.
  public static boolean getIsOnset() {
    return _beat.isOnset();
  }

  //Getter for the current level of the song.
  public static float getLevel() {
    return _mix.level();
  }

  //Getter for the title of the song.
  public static String getTitle() {
    return _data.title();
  }


  //Getter for the artist of a song.
  public static String getAuthor() {
    return _data.author();
  }

  //Getter for whether or not the song is paused.
  public static boolean getIsPlaying() {
    return _player.isPlaying();
  }

  //Changes whether or not the song is playing based on its current state.
  public static void toggle() {

    //If the song is playing, pause it. Otherwise, play it.
    if (_player.isPlaying()) {
      _player.pause();
      _paused = true;
    } else {
      _player.play();
      _paused = true;
    }
  }

  //Changes the gain in increments of 1. Called volume for semantic reasons.
  //boolean isUp determines whether the gain is being increased or decreased.
  //int mouseWheelValue is the number of turns of the wheel.
  public static void changeVolume(boolean isUp, int mouseWheelValue) {

    int increment = mouseWheelValue != 0 ? mouseWheelValue : 10;

    //Increments or decrements the gain based on the passed-in value.
    _volume += (isUp ? increment : increment * -1);

    //Caps value between -50 and 50.
    if (_volume < -50) _volume = -50;
    else if (_volume > 50) _volume = 50;

    //Set the gain to the new value.
    _player.setGain(_volume);
  }


  //Changes the intensity in increments of 10.
  //boolean isUp determines whether the intensity is being increased or decreased.
  public static void changeIntensity(boolean isUp) {

    //Determines if the intensity will increate or decrease.
    int increment = isUp ? 10 : -10;

    //Increments or decrements the intensity based on the passed-in value.
    _intensity += increment;

    //Caps value between -50 and 50.
    if (_intensity < -50) _intensity = -50;
    else if (_intensity > 50) _intensity = 50;
  }

  //Forces the audio to pause.
  public static void stop() {
    if (_player != null) _player.pause();
  }

  //Getter for the loudness of the song.
  public static int getVolume() {
    return _volume;
  }

  //Setter for the direction of the sound.
  public static void setPan(float value) {

    //Clamp the value between -1 and 1.
    if (value < -1) value = -1;
    else if (value > 1) value = 1;

    //Set the pan to that value;
    _player.setPan(value);
  }

  //Getter for the direction of the sound.
  public static float getPan() {
    return _player.getPan();
  }

  //Getter for the intensity of the effects.
  public static float getIntensity() {
    return _intensity;
  }


  //Verifies that the song has ended.
  private static void songEnded() {
    
    //If the user didn't pause the song but it is also not playing...
    if (!_paused && !_player.isPlaying()) {
      
      //Move to the next song and update the order.
      _currentSong++;
      updateOrder();
      setup(_app);
    }
  }

  //Looks into the data directory and updates the files.
  private static void updateAudioFiles() {

    //Gets the file names.
    String[] files = _dataFolder.list();
    
    //Clears the current list.
    _audioFiles.clear();
    
    //For each file in the directory...
    for (String file : files) {
      //If the file is an mp3, add it to the queue.
      if(file.endsWith(".mp3")) _audioFiles.add(file);
    }
  }
  
  //Getter for the state of the song order.
  public static boolean getUnshuffled() {
    return _unshuffled;
  }
  
  //Updates the order of the songs to be played.
  private static void updateOrder() {
    
    //Clears the current order.
    _order.clear();
    
    //Checks for new or removed files.
    updateAudioFiles();
    
    //Fetches the number of songs.
    int numberOfSongs = _audioFiles.size();
    
    //If the songs are not shuffled...
    if (_unshuffled) {
      
      //Play the songs in numerical order.
      for(int i = 0; i < numberOfSongs; i++) {
        _order.add(i);
      }
      
    } 
    
    //Otherwise...
    else {
      
      //Create a list of numbers that go up to 1 less than the number of songs.
      ArrayList<Integer> numbers = new ArrayList<Integer>();
      for(int i = 0; i < numberOfSongs; i++) {
        numbers.add(i);
      }
      
      //Fetch a random number from that list of numbers and move it to the order array, removing it from the number list to prevent duplicates.
      for(int i = 0; i < numberOfSongs; i++) {
        int index = (int)_app.random(0, numbers.get(numbers.size() -1));
        _order.add(numbers.get(index));
        numbers.remove(index);
      }
    }
  }


  //Randomized the order of the tracks.
  public static void shuffle() {
    
    //Inverts the shuffle state.
    _unshuffled = !_unshuffled;
    
    //Updates the order of the songs to be played.
    updateOrder();
    
  }
}
