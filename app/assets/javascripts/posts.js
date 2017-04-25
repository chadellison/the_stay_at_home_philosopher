$(document).ready(function() {
  $.ajax({
    type: "GET",
    url: "/api/v1/posts.json",
    success: function(posts) {
      renderPosts(posts)
    },
    error: function(errors) {
      alert(JSON.parse(errors.responseText)["errors"]);
    }
  })

  $('.submit-post').on('click', function() {
    $.ajax({
      type: "POST",
      url: "/api/v1/posts.json",
      body: JSON.stringify({
        post: {
          // title: params.name,
          // author: params.type,
          // token: params.abv,
          // body: params.brand
        },
        token: params.token
      })
    })
  })

  function renderPosts(posts) {
    $.each(posts, function(index, post) {
      let title = post.attributes.title
      let body = post.attributes.body
      let author = post.relationships.author

      $('#posts').append(
        "<div class='post'>" + "Title: " + title + "</div>" +
        "<div class='post'>" + "Body: " + body + "</div>" +
        "<div class='post'>" + "Auther: " + author + "</div>"
      )
    })
  }
})
