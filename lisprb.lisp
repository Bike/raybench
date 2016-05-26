(defparameter *width* 1280)
(defparameter *height* 720)
(defparameter *samples* 50)
(defparameter *max-depth* 5)

(defmacro v-x (v)
  `(nth 0 ,v))

(defmacro v-y (v)
  `(nth 1 ,v))

(defmacro v-z (v)
  `(nth 2 ,v))

(defun v-add (v1 v2)
  (mapcar #'+ v1 v2))

(defun v-sub (v1 v2)
  (mapcar #'- v1 v2))

(defun v-mul (v1 v2)
  (mapcar #'* v1 v2))

(defun v-mul-s (v1 s)
    (v-mul v1 (list s s s)))

(defun v-div (v1 v2)
  (mapcar #'/ v1 v2))

(defun v-div-s (v1 s)
    (v-div v1 (list s s s)))

(defun v-dot (v1 v2)
  (apply #'+ (v-mul v1 v2)))

(defun v-norm (v1)
  (sqrt (v-dot v1 v1)))

(defun v-unit (v1)
  (v-div v1 (v-norm v1)))

;;Ray stuff
(defun ray-new (origin direction) 
  (list origin direction))

(defmacro ray-origin (ray) 
  `(nth 0 ,ray))

(defmacro ray-direction (ray) 
  `(nth 1 ,ray))

;;Hit stuff
(defun hit-new (dist point normal) 
  (list dist point normal))

;;Camera
(defmacro camera-new (eye lt rt lb)
  `(:camera ,eye ,lt ,rt ,lb))

(defmacro camera-eye (camera)
  `(nth 1 ,camera))

(defmacro camera-lt (camera)
  `(nth 2 ,camera))

(defmacro camera-rt (camera)
  `(nth 3 ,camera))

(defmacro camera-lb (camera)
  `(nth 4 ,camera))

;;Sphere
(defun sphere-new (center radius color is_light)
  (list center radius color is_light))

(defun sphere-hit (sphere ray)
  "To implement"
  nil)

(defun world-new ()
  (list (camera-new '(0 4.5 75) '(-8 9 50) '(8 9 50) '(-8 0 50))
        (list (sphere-new '(0 -10002 0) 9999 '(1 1 1) nil)
              (sphere-new '(-10012 0 0) 9999 '(1 0 0) nil)
              (sphere-new '(10012 0 0) 9999 '(0 1 0) nil)
              (sphere-new '(0 0 -10012) 9999 '(1 1 1) nil)
              (sphere-new '(0 10012 0) 9999 '(1 1 1) t)
              (sphere-new '(-5 0 2) 2 '(1 1 0) nil)
              (sphere-new '(0 5 -1) 4 '(1 0 0) nil)
              (sphere-new '(8 5 -1) 2 '(0 0 1) nil))))

(defun world-camera (world)
  (nth 0 world))

(defun world-spheres (world)
  (nth 2 world))

(defun to-255 (color)
  (let ((c255 (mapcar #'* color '(255.9 255.9 255.9))))
    (mapcar #'floor c255)))
                
(defun writeppm (data) 
  (with-open-file (ppm "lisprb.ppm" :direction :output :if-exists :supersede)
    (format ppm "P3~%~A ~A~%255~%" *width* *height*)
    (loop for row in data do
          (loop for color in row do
                (format ppm "~{~A ~} " (to-255 color)))
          (format ppm "~%"))))

(defun main ()
  (let* ((world (world-new))
        (camera (world-camera world))
        (vdu (v-div-s (v-sub (camera-rt camera) (camera-lt camera)) *width*))
        (vdv (v-div-s (v-sub (camera-lb camera) (camera-lt camera)) *height*))
        (data (loop for y from 0 to (- *height* 1) collect
                (loop for x from 0 to (- *width* 1) collect
                  (let* ((color '(0 0 0))
                         (ray (ray-new (camera-eye camera) '(0 0 0))))
                    (loop for i from 1 to *samples* do
                          
                    )
                  ))))
        (writeppm data)))


;;(main)
