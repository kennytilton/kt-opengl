;;; -*- mode: Lisp; Syntax: Common-Lisp; Package: kt-opengl; -*-
;;;
;;; Copyright (c) 2006 by Kenneth William Tilton
;;;
;;; Permission is hereby granted, free of charge, to any person obtaining a
;;; copy of this software and associated documentation files (the "Software"),
;;; to deal with the Software without restriction, including without limitation
;;; the rights to use, copy, modify, merge, publish, distribute, sublicense,
;;; and/or sell copies of the Software, and to permit persons to whom the
;;; Software is furnished to do so, subject to the following conditions:
;;;
;;; The above copyright notice and this permission notice shall be included in 
;;; all copies or substantial portions of the Software.
;;;
;;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
;;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
;;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
;;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
;;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
;;; FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
;;; DEALINGS IN THE SOFTWARE.
;;;
;;; $Id: colors.lisp,v 1.10 2008/04/11 09:23:07 ktilton Exp $

(in-package #:kt-opengl)

;;; ===========================================================================
;;; Data Definitions
;;; ===========================================================================

(defstruct rgb ;;/// just use ogl native struct?
  (r 0 )
  (g 0 )
  (b 0 ))

(defstruct rgba
  (r   0.0f0)
  (g   0.0f0)
  (b   0.0f0)
  (a   1.0f0)
  (fo  0)    ;; fo = foreign ptr address
  (id  nil))

(defparameter *known-colors* '()
  "Known colors, safed as cons of color-name and rgba-color struct.")

;;; ===========================================================================
;;; Utilities / Helper functions and macros
;;; ===========================================================================

;;; ---------------------------------------------------------------------------
;;; MK-RGBA                                                           FUNCTION
;;; ---------------------------------------------------------------------------
;;;
;;; Make up a struct to hold RGBA information.
;;; Allocates foreign memory to hold a vector of 4 floats to accomodate
;;; the RGBA values of the color.
;;;
;;; Status: RELEASED

(defun mk-rgba (red green blue alpha &optional id)
  (let* ((color-4fv-ptr     (foreign-alloc :float :count 4))
	 (color-rgba-struct (make-rgba
			     :r (/ red   255.0f0) 
			     :g (/ green 255.0f0)
			     :b (/ blue  255.0f0)
			     :a (/ alpha 255.0f0)
			     :fo color-4fv-ptr)))
    (setf (mem-aref color-4fv-ptr :float 0)
	  (rgba-r color-rgba-struct))
    (setf (mem-aref color-4fv-ptr :float 1)
	  (rgba-g color-rgba-struct))
    (setf (mem-aref color-4fv-ptr :float 2)
	  (rgba-b color-rgba-struct))
    (setf (mem-aref color-4fv-ptr :float 3)
	  (rgba-a color-rgba-struct))
    (when id
      (setf (rgba-id color-rgba-struct) id))
    color-rgba-struct))

;;; ---------------------------------------------------------------------------
;;; DEFINE-OGL-RGBA-COLOR                                                MACRO
;;; ---------------------------------------------------------------------------
;;;
;;; Define a constant that holds a RGBA struct with the color information.
;;; Also add the color to the list of known colors (special var *known-
;;; color*) and export the symbol. 
;;;
;;; Status: RELEASED

(defmacro define-ogl-rgba-color (color-name red green blue alpha)
  `(let ((rgba-color (mk-rgba ,red ,green ,blue ,alpha ',color-name)))
     (prog1
         ;; Possibly due to aggressive compile settings, OpenMCL will try
         ;; to inline these constants and fail because there's no
         ;; appropriate MAKE-LOAD-FORM method. I'm not sure whether
         ;; inlining it is a good idea because the RGBA-COLOR structure
         ;; contains a foreign pointer. So, for now, let's avoid inlining
         ;; instead of writing a MAKE-LOAD-FORM method for this
         ;; structure. --luis 
         (#-openmcl defconstant #+openmcl defparameter ,color-name rgba-color)
       (pushnew rgba-color *known-colors*)
       (utils-kt::export! ,color-name))))

;;; ---------------------------------------------------------------------------
;;; PRINT-OBJECT for RGBA                                               METHOD
;;; ---------------------------------------------------------------------------
;;;
;;; Status: RELEASED

(defmethod print-object ((self rgba) stream)
  (format stream
	  "#<RGBA-COLOR ~A * R: ~A G: ~A B: ~A A: ~A @ FGN-PTR-ADDR: 0x~X>"
	  (rgba-id self)
	  (rgba-r  self)
	  (rgba-g  self)
	  (rgba-b  self)
	  (rgba-a  self)
	  (rgba-fo self)))

;;; Some helper functions

(defun wrap-rgba (rgba-foreign)
  (make-rgba :fo rgba-foreign))

(defun make-opengl-rgba (r g b a)
  (let* ((co (fgn-alloc :float 4 :make-opengl-rgba))
         (c (make-rgba :fo co)))
    (setf (cffi:mem-aref co :float 0) (* 1.0 r))
    (setf (cffi:mem-aref co :float 1) (* 1.0 g))
    (setf (cffi:mem-aref co :float 2) (* 1.0 b))
    (setf (cffi:mem-aref co :float 3) (* 1.0 a))
    c))

(defun rgba-clear-color (rgba &aux (co (rgba-fo rgba)))
  (gl-clear-color
   (cffi:mem-aref co :float 0)
   (cffi:mem-aref co :float 1)
   (cffi:mem-aref co :float 2)
   (cffi:mem-aref co :float 3)))

;;; ---------------------------------------------------------------------------
;;; SET-COLOR                                                         FUNCTION
;;; ---------------------------------------------------------------------------
;;;
;;; Takes a color defined by define-ogl-rgba-color and calls gl-color4f to
;;; set the color.
;;;
;;; Status: RELEASED

(defun set-color (rgba)
  #+doesnotwork (gl-color4f (rgba-r rgba)
	      (rgba-g rgba)
	      (rgba-b rgba)
	      (rgba-a rgba))
  (gl-color3f (rgba-r rgba)
	      (rgba-g rgba)
	      (rgba-b rgba))
  )

;;; ---------------------------------------------------------------------------
;;; SET-CLEAR-COLOR                                                   FUNCTION
;;; ---------------------------------------------------------------------------
;;;
;;; Set the clear color, taking a color defined by define-ogl-rgba-color as
;;; parameter.
;;;
;;; Status: RELEASED

(defun set-clear-color (rgba)
  (gl-clear-color (rgba-r rgba)
	          (rgba-g rgba)
	          (rgba-b rgba)
	          (rgba-a rgba)))

;;; ---------------------------------------------------------------------------
;;; WITH-COLOR                                                           MACRO
;;; ---------------------------------------------------------------------------
;;;
;;; Execute body after setting a color and restore previuously set color as
;;; has been set before executing body.
;;;
;;; Status: RELEASED

(defmacro with-color (rgba &body body)
  (let ((ptr (gensym)))
    `(if ,rgba
       (with-foreign-object (,ptr 'glint 4)
	 (gl-get-integerv GL_CURRENT_COLOR ,ptr)
	 (unwind-protect
	      (progn
		(set-color ,rgba)
		,@body)
	   (glcolor4i (mem-aref ,ptr 'glint 0)
		      (mem-aref ,ptr 'glint 1)
		      (mem-aref ,ptr 'glint 2)
		      (mem-aref ,ptr 'glint 3))))
       ,@body)))

;;; ---------------------------------------------------------------------------
;;; EXPORT SYMBOLS
;;; ---------------------------------------------------------------------------

(utils-kt::export!
  set-color
  set-clear-color
  define-ogl-rgba-color
  rgba-r
  rgba-g
  rgba-g
  rgba-a
  rgba-id
  rgba-fo
  make-rgba
  with-color
  wrap-rgba
  make-opengl-rgba
  rgba-clear-color
  *known-colors*
  +NO-COLOR-CHANGE+
  )

;;; ===========================================================================
;;; Color definitions
;;; ===========================================================================

(defconstant +NO-COLOR-CHANGE+ nil
  "Macro WITH-COLOR uses NIL as a discriminator for determining when to not change color but just to execute the body") 

;;; RGBA simple colors

(define-ogl-rgba-color +RED+                              255   0   0 255)
(define-ogl-rgba-color +DARK-RED+                              127   0   0 255)
(define-ogl-rgba-color +GREEN+                              0 255   0 255)
(define-ogl-rgba-color +BLUE+                               0   0 255 255)

(define-ogl-rgba-color +WHITE+                              255   255   255 255)
(define-ogl-rgba-color +BLACK+                              0   0   0 255)
(define-ogl-rgba-color +GRAY+                             128 128 128 255)
(define-ogl-rgba-color +TURQUOISE+                          0 255 255 255)
(define-ogl-rgba-color +PURPLE+                           255   0 255 255)

(define-ogl-rgba-color +DARK-GREEN+                         0 128   0 255)
(define-ogl-rgba-color +DARK-BLUE+                          0   0  64  50)
(define-ogl-rgba-color +DARK-GRAY+                         64  64  64 255)

(define-ogl-rgba-color +LIGHT-BLUE+                       127 127 255 255)
(define-ogl-rgba-color +YELLOW+                           255 255 0 255)
(define-ogl-rgba-color +gold+                             255 215 0 255)
(define-ogl-rgba-color +LIGHT-YELLOW+                     255 255 127 255)
(define-ogl-rgba-color +LIGHT-GRAY+                       192 192 192 255)

(define-ogl-rgba-color +orange+                       255 127 0 255)
(define-ogl-rgba-color +saddle-brown+ 139 69 19 255)
(define-ogl-rgba-color +brown+ 139 69 19 255)

;;; PANTONE colors as defined by graphics design s/w Art Director's Toolkit V.5

;;; PANTONE SOLID COATED

(define-ogl-rgba-color +PANTONE-YELLOW-C+                 254 223   0 255)
(define-ogl-rgba-color +PANTONE-YELLOW-012-C+             255 213   0 255)
(define-ogl-rgba-color +PANTONE-ORANGE-021-C+             255  88   0 255)
(define-ogl-rgba-color +PANTONE-WARM-RED-C+               247  64  58 255)
(define-ogl-rgba-color +PANTONE-RED-032-C+                237  41  57 255)
(define-ogl-rgba-color +PANTONE-RUBIN-RED-C+              202   0  93 255)
(define-ogl-rgba-color +PANTONE-RHODAMINE-RED-C+          224  17 157 255)
(define-ogl-rgba-color +PANTONE-PURPLE-C+                 182  52 187 255)
(define-ogl-rgba-color +PANTONE-VIOLET-C+                  75   8 161 255)
(define-ogl-rgba-color +PANTONE-BLUE-072-C+                 0  24 168 255)
(define-ogl-rgba-color +PANTONE-REFLEX-BLUE-C+              0  35 149 255)
(define-ogl-rgba-color +PANTONE-PROCESS-BLUE-C+             0 136 206 255)
(define-ogl-rgba-color +PANTONE-GREEN-C+                    0 173 131 255)
(define-ogl-rgba-color +PANTONE-BLACK-C+                   42  38  35 255)

(define-ogl-rgba-color +PANTONE-PROCESS-YELLOW-C+         249 227   0 255)
(define-ogl-rgba-color +PANTONE-PROCESS-MAGENTA-C+        209   0 116 255)
(define-ogl-rgba-color +PANTONE-PROCESS-CYAN-C+             0 159 218 255)
(define-ogl-rgba-color +PANTONE-PROCESS-BLACK-C+           30  30  30 255)

(define-ogl-rgba-color +PANTONE-HEXACHROME-YELLOW-C+      255 224   0 255)
(define-ogl-rgba-color +PANTONE-HEXACHROME-ORANGE-C+      255 124   0 255)
(define-ogl-rgba-color +PANTONE-HEXACHROME-MAGENTA-C+     222   0 144 255)
(define-ogl-rgba-color +PANTONE-HEXACHROME-CYAN-C+          0 143 208 255)
(define-ogl-rgba-color +PANTONE-HEXACHROME-GREEN-C+         0 176  74 255)
(define-ogl-rgba-color +PANTONE-HEXACHROME-BLACK-C+        32  33  33 255)

(define-ogl-rgba-color +PANTONE-100-C+                    243 236 122 255)
(define-ogl-rgba-color +PANTONE-101-C+                    245 236  90 255)
(define-ogl-rgba-color +PANTONE-102-C+                    250 231   0 255)
(define-ogl-rgba-color +PANTONE-103-C+                    198 172   0 255)
(define-ogl-rgba-color +PANTONE-104-C+                    174 154   0 255)
(define-ogl-rgba-color +PANTONE-105-C+                    134 122  36 255)

(define-ogl-rgba-color +PANTONE-400-C+                    203 199 191 255)
(define-ogl-rgba-color +PANTONE-401-C+                    182 177 169 255)
(define-ogl-rgba-color +PANTONE-402-C+                    169 163 155 255)
(define-ogl-rgba-color +PANTONE-403-C+                    146 139 129 255)
(define-ogl-rgba-color +PANTONE-404-C+                    119 111 101 255)
(define-ogl-rgba-color +PANTONE-405-C+                     95  87  79 255)
(define-ogl-rgba-color +PANTONE-406-C+                    205 198 192 255)
(define-ogl-rgba-color +PANTONE-407-C+                    181 172 166 255)
(define-ogl-rgba-color +PANTONE-408-C+                    162 151 145 255)
(define-ogl-rgba-color +PANTONE-409-C+                    141 129 123 255)
(define-ogl-rgba-color +PANTONE-410-C+                    118 106 101 255)

(define-ogl-rgba-color +PANTONE-WARM-GRAY-1-C+            224 222 216 255)
(define-ogl-rgba-color +PANTONE-WARM-GRAY-2-C+            213 210 202 255)
(define-ogl-rgba-color +PANTONE-WARM-GRAY-3-C+            199 194 186 255)
(define-ogl-rgba-color +PANTONE-WARM-GRAY-4-C+            183 177 169 255)
(define-ogl-rgba-color +PANTONE-WARM-GRAY-5-C+            174 167 159 255)
(define-ogl-rgba-color +PANTONE-WARM-GRAY-6-C+            165 157 149 255)
(define-ogl-rgba-color +PANTONE-WARM-GRAY-7-C+            152 143 134 255)
(define-ogl-rgba-color +PANTONE-WARM-GRAY-8-C+            139 129 120 255)
(define-ogl-rgba-color +PANTONE-WARM-GRAY-9-C+            130 120 111 255)
(define-ogl-rgba-color +PANTONE-WARM-GRAY-10-C+           118 106  98 255)
(define-ogl-rgba-color +PANTONE-WARM-GRAY-11-C+           103  92  83 255)

(define-ogl-rgba-color +PANTONE-COOL-GRAY-1-C+            224 225 221 255)
(define-ogl-rgba-color +PANTONE-COOL-GRAY-2-C+            213 214 210 255)
(define-ogl-rgba-color +PANTONE-COOL-GRAY-3-C+            201 202 200 255)
(define-ogl-rgba-color +PANTONE-COOL-GRAY-4-C+            188 189 188 255)
(define-ogl-rgba-color +PANTONE-COOL-GRAY-5-C+            178 180 179 255)
(define-ogl-rgba-color +PANTONE-COOL-GRAY-6-C+            173 175 175 255)
(define-ogl-rgba-color +PANTONE-COOL-GRAY-7-C+            154 155 156 255)
(define-ogl-rgba-color +PANTONE-COOL-GRAY-8-C+            139 141 142 255)
(define-ogl-rgba-color +PANTONE-COOL-GRAY-9-C+            116 118 120 255)
(define-ogl-rgba-color +PANTONE-COOL-GRAY-10-C+            97  99 101 255)
(define-ogl-rgba-color +PANTONE-COOL-GRAY-11-C+            77  79  83 255)


;;; PANTONE SOLID UNCOATED

(define-ogl-rgba-color +PANTONE-YELLOW-U+                 255 230   0 255)
(define-ogl-rgba-color +PANTONE-YELLOW-012-U+             255 218   0 255)
(define-ogl-rgba-color +PANTONE-ORANGE-021-U+             255 115  12 255)
(define-ogl-rgba-color +PANTONE-WARM-RED-U+               254  97  92 255)
(define-ogl-rgba-color +PANTONE-RED-032-U+                243  85  98 255)
(define-ogl-rgba-color +PANTONE-RUBIN-RED-U+              212  72 126 255)
(define-ogl-rgba-color +PANTONE-RHODAMINE-RED-U+          227  81 162 255)
(define-ogl-rgba-color +PANTONE-PURPLE-U+                 189  85 187 255)
(define-ogl-rgba-color +PANTONE-VIOLET-U+                 117  87 177 255)
(define-ogl-rgba-color +PANTONE-BLUE-072-U+                57  69 166 255)
(define-ogl-rgba-color +PANTONE-REFLEX-BLUE-U+             53  71 147 255)
(define-ogl-rgba-color +PANTONE-PROCESS-BLUE-U+             0 131 197 255)
(define-ogl-rgba-color +PANTONE-GREEN-U+                    0 170 135 255)
(define-ogl-rgba-color +PANTONE-BLACK-U+                   96  91  85 255)

(define-ogl-rgba-color +PANTONE-PROCESS-YELLOW-U+         250 230  35 255)
(define-ogl-rgba-color +PANTONE-PROCESS-MAGENTA-U+        215  77 132 255)
(define-ogl-rgba-color +PANTONE-PROCESS-CYAN-U+             0 159 214 255)
(define-ogl-rgba-color +PANTONE-PROCESS-BLACK-U+           85  81  80 255)

(define-ogl-rgba-color +PANTONE-HEXACHROME-YELLOW-U+      255 226  16 255)
(define-ogl-rgba-color +PANTONE-HEXACHROME-ORANGE-U+      255 126  56 255)
(define-ogl-rgba-color +PANTONE-HEXACHROME-MAGENTA-U+     223  62 145 255)
(define-ogl-rgba-color +PANTONE-HEXACHROME-CYAN-U+          0 151 209 255)
(define-ogl-rgba-color +PANTONE-HEXACHROME-GREEN-U+         0 177 102 255)
(define-ogl-rgba-color +PANTONE-HEXACHROME-BLACK-U+        82  79  77 255)

(define-ogl-rgba-color +PANTONE-100-U+                    250 239 119 255)
(define-ogl-rgba-color +PANTONE-101-U+                    253 239 103 255)
(define-ogl-rgba-color +PANTONE-102-U+                    255 235  51 255)
(define-ogl-rgba-color +PANTONE-103-U+                    184 163  42 255)
(define-ogl-rgba-color +PANTONE-104-U+                    153 139  57 255)
(define-ogl-rgba-color +PANTONE-105-U+                    129 122  73 255)
(define-ogl-rgba-color +PANTONE-106-U+                    255 234 100 255)
(define-ogl-rgba-color +PANTONE-107-U+                    255 229  82 255)

(define-ogl-rgba-color +PANTONE-400-U+                    197 191 182 255)
(define-ogl-rgba-color +PANTONE-401-U+                    180 174 166 255)
(define-ogl-rgba-color +PANTONE-402-U+                    160 154 147 255)
(define-ogl-rgba-color +PANTONE-403-U+                    148 142 136 255)
(define-ogl-rgba-color +PANTONE-404-U+                    133 127 121 255)
(define-ogl-rgba-color +PANTONE-405-U+                    114 108 103 255)
(define-ogl-rgba-color +PANTONE-406-U+                    195 184 177 255)
(define-ogl-rgba-color +PANTONE-407-U+                    171 161 155 255)
(define-ogl-rgba-color +PANTONE-408-U+                    153 143 138 255)
(define-ogl-rgba-color +PANTONE-409-U+                    141 132 129 255)
(define-ogl-rgba-color +PANTONE-410-U+                    133 124 121 255)

(define-ogl-rgba-color +PANTONE-WARM-GRAY-1-U+            229 224 217 255)
(define-ogl-rgba-color +PANTONE-WARM-GRAY-2-U+            215 209 201 255)
(define-ogl-rgba-color +PANTONE-WARM-GRAY-3-U+            195 188 180 255)
(define-ogl-rgba-color +PANTONE-WARM-GRAY-4-U+            181 173 166 255)
(define-ogl-rgba-color +PANTONE-WARM-GRAY-5-U+            168 161 155 255)
(define-ogl-rgba-color +PANTONE-WARM-GRAY-6-U+            158 151 145 255)
(define-ogl-rgba-color +PANTONE-WARM-GRAY-7-U+            149 142 137 255)
(define-ogl-rgba-color +PANTONE-WARM-GRAY-8-U+            141 134 130 255)
(define-ogl-rgba-color +PANTONE-WARM-GRAY-9-U+            135 128 124 255)
(define-ogl-rgba-color +PANTONE-WARM-GRAY-10-U+           126 119 116 255)
(define-ogl-rgba-color +PANTONE-WARM-GRAY-11-U+           120 113 110 255)

(define-ogl-rgba-color +PANTONE-COOL-GRAY-1-U+            226 225 220 255)
(define-ogl-rgba-color +PANTONE-COOL-GRAY-2-U+            212 212 208 255)
(define-ogl-rgba-color +PANTONE-COOL-GRAY-3-U+            197 198 196 255)
(define-ogl-rgba-color +PANTONE-COOL-GRAY-4-U+            181 182 182 255)
(define-ogl-rgba-color +PANTONE-COOL-GRAY-5-U+            172 173 174 255)
(define-ogl-rgba-color +PANTONE-COOL-GRAY-6-U+            163 165 166 255)
(define-ogl-rgba-color +PANTONE-COOL-GRAY-7-U+            152 153 155 255)
(define-ogl-rgba-color +PANTONE-COOL-GRAY-8-U+            143 145 147 255)
(define-ogl-rgba-color +PANTONE-COOL-GRAY-9-U+            133 135 138 255)
(define-ogl-rgba-color +PANTONE-COOL-GRAY-10-U+           127 129 132 255)
(define-ogl-rgba-color +PANTONE-COOL-GRAY-11-U+           117 119 123 255)
