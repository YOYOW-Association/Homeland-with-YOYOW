window.PostView = Backbone.View.extend
  el: "body"
  events:
    "click .editor-toolbar .preview": "togglePreviewView"
    "change #file-post_cover_image": "changeCoverImage"
    "click #post_cover_image": "selectCoverImage"
    "click #btn-upload_cover_image": "uploadCoverImage"
    "click #btn-delete_cover_image": "deleteCoverImage"

  initialize: (opts) ->
    $("<div id='preview' class='markdown form-control' style='display:none;'></div>").insertAfter( $('#post_body') )
    window._editor = new Editor()

  togglePreviewView: (e) ->
    is_preview = $(e.target).hasClass('active')
    if is_preview
      $('#post_body').show()
      $('#preview').hide()
      $(e.target).removeClass('active')
    else
      $(e.target).addClass('active')
      $('#preview').html('Loading...')
      $('#post_body').hide()
      $('#preview').show()
      $.post '/posts/preview', {body: $('#post_body').val()}, (data)->
        $('#preview').html(data)
        false

    false

  selectCoverImage: (e)->
    $('#file-post_cover_image').click()

  changeCoverImage: (e) ->
    $elem = $(e.target)

    if $elem.val().trim().length == 0
      if $('#post_cover_image').val().trim().length > 0
        return
      @_updateLabel('选择封面图片')
    else
      @_updateLabel($elem.val())

  uploadCoverImage: (e) ->
    file = $('#file-post_cover_image').prop('files')[0];
    return unless file
    
    @_uploadCoverImage(file, file.name)

  _uploadCoverImage: (item, filename) ->
    self = @
    formData = new FormData()
    formData.append "file", item, filename
    $.ajax
      url: '/photos'
      type: "POST"
      data: formData
      dataType: "JSON"
      processData: false
      contentType: false
      beforeSend: ->
        self.showUploading()
      success: (e, status, res) ->
        self.appendImageFromUpload(res.responseJSON.url)
        self.restoreUploaderStatus()
      error: (res) ->
        App.alert("上传失败")
        self.restoreUploaderStatus()
      complete: ->
        self.restoreUploaderStatus()

  deleteCoverImage: (e) ->
    @_updateLabel('')

  appendImageFromUpload : (src) ->
    @_updateLabel(src)

  showUploading: () ->
    $("#btn-upload_cover_image").hide()
    if $("#btn-upload_cover_image").parent().find("span.loading").length == 0
      $("#btn-upload_cover_image").before("<span class='loading'><i class='fa fa-circle-o-notch fa-spin'></i></span>")

  restoreUploaderStatus: ->
    $("#btn-upload_cover_image").parent().find("span.loading").remove()
    $("#btn-upload_cover_image").show()

  _updateLabel: (label) ->
    $('#post_cover_image').val(label)


document.addEventListener 'turbolinks:load',  ->
  window._postView = new PostView()
  $("#main-hot-banner").carousel 'cycle'

  $('.carousel-inner').swipeleft ->
    $("#main-hot-banner").carousel 'next'

  $('.carousel-inner').swiperight ->
    $("#main-hot-banner").carousel 'prev'
