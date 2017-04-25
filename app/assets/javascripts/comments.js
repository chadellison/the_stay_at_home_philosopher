$(document).ready(function() {
  fetchComments()

  function fetchComments() {
    $.ajax({
      type: "GET",
      url: "/api/v1/comments.json",
      success: function(comments) {
        renderComments(comments)
      },
      error: function(errors) {
        alert(JSON.parse(errors.responseText)["errors"])
      }
    })
  }

  // $('.submit-comment').on('click', function() {
  //   let title = $('.title-input').val()
  //   let body = $('.body-input').val()
  //
  //   $.ajax({
  //     type: "POST",
  //     url: "/api/v1/posts.json",
  //     data: {
  //       post: {
  //         title: title,
  //         body: body
  //       }
  //     },
  //     success: function(post) {
  //       $('.add-post-form').fadeOut()
  //       removePosts()
  //       fetchPosts()
  //     },
  //     error: function(errors) {
  //       let errorMessage = JSON.parse(errors.responseText).errors
  //       alert(errorMessage)
  //     }
  //   })
  // })

  function renderComments(comments) {
    $.each(comments, function(index, comment) {
      let body = comment.attributes.body
      let author = comment.relationships.author

      $('#comments').append(
        "<br>" +
        "<div class='comment'>" + body +
        "<div class='comment'>" + "Author: " + author + "</div>" +
        "<br>"
      )
    })
  }
})
