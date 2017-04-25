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

  $('.submit-comment').on('click', function() {
    let body = $('.comment-text-box').val()
    let index = window.location.pathname.split("/").length - 1
    let post_id = window.location.pathname.split("/")[index]

    $.ajax({
      type: "POST",
      url: "/api/v1/comments.json",
      data: {
        comment: { body: body, post_id: post_id }
      },
      success: function(comment) {
        removeComments()
        fetchComments()
        $('.comment-text-box').val('')
      },
      error: function(errors) {
        let errorMessage = JSON.parse(errors.responseText).errors
        alert(errorMessage)
        $('.comment-text-box').val('')
      }
    })
  })

  $('.cancel-comment').on('click', function() {
    $('.comment-text-box').val('')
  })

  function removeComments() {
    $('#comments').children().remove()
  }

  function renderComments(comments) {
    $.each(comments['data'], function(index, comment) {
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
