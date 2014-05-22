
class RootGUI extends JFrame {

  JLabel clockLabel = new JLabel("Clock: 0", JLabel.LEFT);
  JLabel phaseLabel = new JLabel("Phase: 0", JLabel.LEFT);


  RootGUI(PApplet app) {
    super("Status");
    println("instantiating RootGUI");
    
    JMenuBar menuBar = new JMenuBar();
    JMenu file = new JMenu("File");
    JMenuItem item = new JMenuItem("Save Config");
    file.add(item);
    menuBar.add(file);
    setJMenuBar(menuBar);
    setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

    Container content = getContentPane();
    content.setLayout(new BoxLayout(content, BoxLayout.PAGE_AXIS));

    content.add(clockLabel);
    content.add(phaseLabel);
  }
}
