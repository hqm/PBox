

  File default_directory  = new File("pbox");
// create 'pbox' dir if not exists
void createDefaultDirectory() {

  boolean b = false;
  if (!default_directory.exists()) {
    /*
             * mkdirs() method creates the directory mentioned by this abstract
     * pathname including any necessary but nonexistent parent
     * directories.
     * 
     * Accordingly it will return TRUE or FALSE if directory created
     * successfully or not. If this operation fails it may have
     * succeeded in creating some of the necessary parent directories.
     */
    b = default_directory.mkdirs();
  }
  if (b)
    System.out.println(default_directory +"  directory successfully created");
  else
    System.out.println("Failed to create "+ default_directory+"  directory");
}




// get json from current config
String getConfigCSV() {
  StringBuffer buf = new StringBuffer();
  // write out the clock phase as first line
  buf.append(clockPhase()+"\n");

  for (Cell cell : grid.values ()) {
    buf.append(cell.getCSV() + "\n");
  }
  return buf.toString();
}



JFileChooser chooser = new JFileChooser(default_directory);

void saveConfigToFile() {
  chooser.setFileFilter(chooser.getAcceptAllFileFilter());
  int returnVal = chooser.showSaveDialog(null);
  if (returnVal == JFileChooser.APPROVE_OPTION) 
  {
    String path=chooser.getSelectedFile().getAbsolutePath();
    String filename=chooser.getSelectedFile().getName();
    if (!(filename.indexOf(".")>0) && !path.endsWith(".pbox")) {
      path = path +".pbox";
    }
    try {
      FileWriter fout = new FileWriter(path);
      fout.write(getConfigCSV());
      fout.close();
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
  }
}

void loadConfigFromFile() {
  clearWorld();

  FileFilter pboxFilter = new FileNameExtensionFilter("PBox files", "pbox");

  //Attaching Filter to JFileChooser object
  chooser.addChoosableFileFilter(pboxFilter);
  int returnVal = chooser.showOpenDialog(null);
  int phase = 0;
  if (returnVal == JFileChooser.APPROVE_OPTION) {
    try {
      String path=chooser.getSelectedFile().getAbsolutePath();
      BufferedReader in = new BufferedReader(new FileReader(path));
      String line = null;
      // get phase
      line = in.readLine();
      phase = Integer.parseInt(line.trim());

      while (true) {
        line = in.readLine();
        if (line == null) break;
        String vals[] = line.trim().split(",");
        int x = Integer.parseInt(vals[0]);
        int y = Integer.parseInt(vals[1]);
        int z = Integer.parseInt(vals[2]);
        int s = Integer.parseInt(vals[3]);
        addCell(x, y, z, s);
      }

      in.close();
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
  }
  stashCells(phase);
  clock = phase;
}

void loadModuleFromFile() {
  FileFilter pboxFilter = new FileNameExtensionFilter("PBox files", "pbox");

  //Attaching Filter to JFileChooser object
  chooser.addChoosableFileFilter(pboxFilter);
  int returnVal = chooser.showOpenDialog(null);
  if (returnVal == JFileChooser.APPROVE_OPTION) {
    try {
      String path=chooser.getSelectedFile().getAbsolutePath();
      BufferedReader in = new BufferedReader(new FileReader(path));
      String line = null;
      // get phase
      line = in.readLine();
      int phase = Integer.parseInt(line.trim());
      // we're not using phase in this right now, module just gets plunked down at current phase

      while (true) {
        line = in.readLine();
        if (line == null) break;
        String vals[] = line.trim().split(",");
        int x = Integer.parseInt(vals[0]);
        int y = Integer.parseInt(vals[1]);
        int z = Integer.parseInt(vals[2]);
        int s = Integer.parseInt(vals[3]);
        addModuleCell(x, y, z, s);
      }

      in.close();
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
  }
}

