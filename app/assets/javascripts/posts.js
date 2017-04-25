$(document).ready(function() {
  fetchPosts()

  function fetchPosts() {
    $.ajax({
      type: "GET",
      url: "/api/v1/posts.json",
      success: function(posts) {
        renderPosts(posts)
      },
      error: function(errors) {
        alert(JSON.parse(errors.responseText)["errors"])
      }
    })
  }

  $('.add-post').on('click', function() {
    $('.add-post-form').fadeIn()
  })

  $('.cancel-submission').on('click', function() {
    $('.add-post-form').fadeOut()
  })

  $('.submit-post').on('click', function() {
    let title = $('.title-input').val()
    let body = $('.body-input').val()

    $.ajax({
      type: "POST",
      url: "/api/v1/posts.json",
      data: {
        post: {
          title: title,
          body: body
        }
      },
      success: function(post) {
        $('.add-post-form').fadeOut()
        removePosts()
        fetchPosts()
      },
      error: function(errors) {
        let errorMessage = JSON.parse(errors.responseText).errors
        alert(errorMessage)
      }
    })
  })

  function removePosts() {
    $('#posts').children().remove()
  }

  function renderPosts(posts) {
    $.each(posts, function(index, post) {
      let title = post.attributes.title
      let body = post.attributes.body.substring(0, 20)
      let author = post.relationships.author
      let postLink = '/posts/' + post.id

      $('#posts').append(
        "<br>" +
        "<div class='post'>" + "Title: " + "<a href='" + postLink + "'>" + title + "</a>" + "</div>" +
        "<div class='post'>" + "Body: " + "<a href='" + postLink + "'>" + body + "</a>" + "</div>" +
        "<div class='post'>" + "Auther: " + author + "</div>" +
        "<br>"
      )
    })
  }
})
