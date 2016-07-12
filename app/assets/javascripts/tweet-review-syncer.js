(function(doc) {
  doc.addEventListener('turbolinks:load', function() {
    var syncButton;
    syncButton = doc.getElementById('sync_button');
    if (!syncButton) {
      return;
    }

    syncButton.addEventListener('click', function(event) {
      event.preventDefault();
      doc.getElementById('tweet_review_sync').value = true;
      doc.getElementsByClassName('simple_form')[0].submit();
    });
  });
})(document);
