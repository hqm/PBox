
class RootGUI extends JFrame implements ActionListener, 
ItemListener {

  JLabel clockLabel = new JLabel("Clock: 0", JLabel.LEFT);
  JLabel phaseLabel = new JLabel("Phase: 0", JLabel.LEFT);
  JLabel directionLabel = new JLabel("Direction: forward", JLabel.LEFT);
  JLabel speedLabel = new JLabel("Speed: fast", JLabel.LEFT);
  JLabel wrapLabel = new JLabel("Wrap: true", JLabel.LEFT);
  JLabel cursorLabel = new JLabel("Cursor: 0,0,0", JLabel.LEFT);
  JLabel debugLabel = new JLabel("Debug: true", JLabel.LEFT);

  JLabel help = new JLabel(HELP_STRING, JLabel.LEFT);


  JMenuItem saveConfigItem = new JMenuItem("Save Config");
  JMenuItem clearItem = new JMenuItem("Clear");
  JMenuItem loadConfig = new JMenuItem("Load Config");
  JMenuItem loadModule = new JMenuItem("Load Module");
  JMenu file = new JMenu("File");

  JButton updateButton = new JButton("UPDATE");
  JButton resetButton = new JButton("RESET");
  JButton clearButton = new JButton("CLEAR");
  JButton stepButton = new JButton("STEP");
  JButton runButton = new JButton("RUN/STOP");



  PBox app;

  RootGUI(PBox app) {
    super("Status");
    println("instantiating RootGUI");
    this.app = app;


    updateButton.addActionListener(this);
    resetButton.addActionListener(this);
    clearButton.addActionListener(this);
    stepButton.addActionListener(this);
    runButton.addActionListener(this);

    JMenuBar menuBar = new JMenuBar();

    file.add(clearItem);
    clearItem.addActionListener(this);

    file.add(saveConfigItem);
    saveConfigItem.addActionListener(this );

    file.add(loadConfig);
    loadConfig.addActionListener(this );

    file.add(loadModule);
    loadModule.addActionListener(this );

    menuBar.add(file);
    setJMenuBar(menuBar);
    setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

    Container content = getContentPane();
    content.setLayout(new BoxLayout(content, BoxLayout.PAGE_AXIS));

    content.add(updateButton);
    content.add(resetButton);
    content.add(clearButton);
    content.add(stepButton);
    content.add(runButton);
    content.add(clockLabel);
    content.add(phaseLabel);
    content.add(directionLabel);
    content.add(speedLabel);
    content.add(wrapLabel);
    content.add(cursorLabel);
    content.add(debugLabel);

    content.add(help);
  }


  void actionPerformed(ActionEvent e) {
    PBox.println("handle action "+e.getActionCommand());
    String cmd = e.getActionCommand();
    if (cmd.equals("Save Config")) {
      app.saveConfigToFile();
    } else if (cmd.equals("Load Config")) {
      app.loadConfigFromFile();
    } else if (cmd.equals("Load Module")) {
      app.loadModuleFromFile();
    } else if (cmd.equals("Clear")) {
      PBox.println("clear world");
      app.loadConfig(0);
    } else if (cmd.equals("UPDATE")) {
      app.stashCells();
    } else if (cmd.equals("RESET")) {
      app.restoreFromStash();
    } else if (cmd.equals("RUN/STOP")) {
      if (app.run) {
        app.run = false;
        app.singleStep = true;
      } else {
        app.run = true;
        app.singleStep = false;
      }
    } else if (cmd.equals("STEP")) {
      app.singleStep = true;
    } else if (cmd.equals("CLEAR")) {
      app.clearWorld();
    }
  }

  void itemStateChanged(ItemEvent e) {
    PBox.println("item state changed "+e);
  }

  static final String HELP_STRING = "<html><br><hr>Help<hr>"
    +"double-click: reset camera position<br>"
    +"B: Beanshell console window<br>"
    +"D: toggle debug logging<br>"
    +"z: forward/reverse direction<br>"
    +"s: toggle fast/slow<br>"
    +"w: wrap mode<br>"
    +"p: place module<br>"
    +"ENTER: toggle cell/end module mode<br>"
    +"q: toggle spherical cells<br>"
    +"h: cursor home"
    +"</html>";
}
