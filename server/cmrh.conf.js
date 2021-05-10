module.exports = {
  generateScopedName: function (name, filepath, css) {
    var baseDir = __dirname.split(/\/|\\/);
    var csspath = filepath
        .split(/\/|\\/)
        .slice(baseDir.length - 1)  // -1 for 'client'
        .join("_")
        .slice(0, -4);
    
    return "_C_C_" + csspath + "__" + name;
  }
}
