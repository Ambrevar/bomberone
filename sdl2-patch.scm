;; Following hack is not required on latest guile-sdl2.
(define-module (sdl2 patch))

(define-public sdl-rect
  (list int int int int))

(define* (render-copy renderer texture #:key srcrect dstrect)
  "Copy TEXTURE to the rendering target of RENDERER."
  (let ((result (ffi:sdl-render-copy (unwrap-renderer renderer)
                                     (unwrap-texture texture)
                                     (if srcrect
                                         (make-c-struct sdl-rect srcrect)
                                         %null-pointer)
                                     (if dstrect
                                         (make-c-struct sdl-rect dstrect)
                                         %null-pointer))))
    (unless (zero? result)
      (sdl-error "render-copy" "failed to copy texture"))))
