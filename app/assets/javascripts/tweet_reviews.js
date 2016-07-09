(function(doc) {
  function debounce(func, wait, immediate) {
  	var timeout;
  	return function() {
  		var context = this, args = arguments;
  		var later = function() {
  			timeout = null;
  			if (!immediate) func.apply(context, args);
  		};
  		var callNow = immediate && !timeout;
  		clearTimeout(timeout);
  		timeout = setTimeout(later, wait);
  		if (callNow) func.apply(context, args);
  	};
  };

  function findAlbum(artistName, albumName) {
    return fetch(['/albums?artist=', artistName, '&album=', albumName].join(''))
      .then(function(response) {
        return response.text().then(function(albums) {
          return albums;
        });
      });
  }

  function searchArtistAlbum(artist, album) {
    if (artist.length > 3 || album.length > 3) {
      return findAlbum(artist, album).then(function(albumsHtml) {
        return albumsHtml;
      });
    } else {
      return {
        then: function() {}
      };
    }
  }

  function showAlbums(albumsHtml) {
    doc.getElementById('album_results').innerHTML = albumsHtml;
  }

  function onAlbumSelect(callback) {
    var albumEls, _i, _len, _albumEl;

    albumEls = doc.getElementsByClassName('album');
    for (_i = 0, _len = albumEls.length; _i < _len; _i++) {
      _albumEl = albumEls.item(_i);
      _albumEl.addEventListener('click', function(event) {
        callback({
          name: this.attributes['data-name'].value,
          artist: this.attributes['data-artist'].value,
          url: this.attributes['data-url'].value
        });
      });
    }
  }

  function autofillAlbumDetails(albumDetails) {
    var albumUrlInput, artistInput, albumInput;
    albumInput = doc.getElementById('tweet_review_album');
    artistInput = doc.getElementById('tweet_review_artist');
    albumUrlInput = doc.getElementById('tweet_review_listen_url');
    albumInput.value = albumDetails.name;
    artistInput.value = albumDetails.artist;
    albumUrlInput.value = albumDetails.url;
  }

  document.addEventListener("DOMContentLoaded", function(event) {
    if (doc.getElementsByClassName('edit_tweet_review').length === 0) {
      return;
    }

    var artistInput, albumInput, autofillButton, loadingEl, errorEl;
    artistInput = doc.getElementById('tweet_review_artist');
    albumInput = doc.getElementById('tweet_review_album');
    autofillButton = doc.getElementById('listen_auto_fill');
    loadingEl = doc.getElementById('album_loader');
    errorEl = doc.getElementById('album_loader_error');

    function search() {
      loadingEl.style = 'display:block';
      errorEl.style = 'display:none';
      doc.getElementById('album_results').innerHTML = '';

      searchArtistAlbum(artistInput.value, albumInput.value)
      .then(showAlbums)
      .then(function() {
        onAlbumSelect(autofillAlbumDetails);
      })
      .then(function() {
        loadingEl.style = '';
      })
      .catch(function() {
        errorEl.style = 'display:block';
      });
    }

    artistInput.addEventListener('keyup', debounce(search, 500));

    albumInput.addEventListener('keyup', debounce(search, 500));

    autofillButton.addEventListener('click', function(event) {
      event.preventDefault();
      search();
    });
  });

})(document);
