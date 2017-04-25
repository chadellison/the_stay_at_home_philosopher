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

  function renderPosts(posts) {
    $.each(posts, function(index, post) {
      let title = post.title
      let body = post.body
      $('#posts').append(
        "<div class='post'>" + "Title: " + title + "</div>" +
        "<div class='post'>" + "Body: " + body + "</div>"
      )
    })
  }
})
