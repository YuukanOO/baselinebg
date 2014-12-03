(function() {

  var BaseLine = (function() {

    function BaseLine() {

    }

    BaseLine.prototype.update = function() {
      var h = $('[name=h]').val();
      var v = $('[name=v]').val();
      var hc = $('[name=hc]').val();
      var vc = $('[name=vc]').val();

      var url = jdomain + '/g/?h=' + h + '&v=' + v + '&hc=' + hc + '&vc=' + vc;

      // Sets body background
      $('body').css('background-image',
        'url("' + url + '")');

      // Sets generated url
      $('.generated-url').html(url);

      // And sets bookmarklet javascript code
      $('a.bookmarklet').attr('href', "javascript: !function(){if(null===document.getElementById(\"baselinebg_ele\")){var e=document.createElement(\"div\");e.id=\"baselinebg_ele\",e.style.cssText=\"background-repeat: repeat;background-image: url('"+url+"');position: fixed;top: 0;left: 0;height: 100%;width: 100%;z-index: 9999\",document.body.appendChild(e)}else document.body.removeChild(document.getElementById(\"baselinebg_ele\"))}();");
    };

    BaseLine.prototype.init = function() {
      $('input').keyup(this.update.bind(this));

      this.update();
    };

    return new BaseLine();

  })();

  $(document).ready(function() {
    BaseLine.init();
  });

})();