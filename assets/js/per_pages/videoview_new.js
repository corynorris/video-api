export default function() {
  const getFileName = function(fullPath) {
    if (fullPath) {
      var startIndex = (fullPath.indexOf('\\') >= 0 ? fullPath.lastIndexOf('\\') : fullPath.lastIndexOf('/'));
      var filename = fullPath.substring(startIndex);

      if (filename.indexOf('\\') === 0 || filename.indexOf('/') === 0) {
        filename = filename.substring(1);
      }
      return filename
    }
  }

  var fileInputs = document.getElementsByClassName("file-input");
  for (var i = 0; i < fileInputs.length; i++) {

    fileInputs[i].addEventListener('change', (e) => {
      var $target = document.getElementById(e.target.dataset.targetDiv);
      $target.innerHTML = getFileName(e.target.value)
    })
  }
}