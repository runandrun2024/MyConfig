; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; ------------------------------------------------------------------------
;; @ 環境変数
;;   (setenv "LANG" "ja_JP.UTF-8")

;; ------------------------------------------------------------------------
;; @ coding system

   ;; 日本語入力のための設定
   (set-keyboard-coding-system 'utf-8)

   (prefer-coding-system 'utf-8-unix)
   (set-file-name-coding-system 'utf-8)
   (setq default-process-coding-system '(utf-8 . utf-8))

;; ------------------------------------------------------------------------
;; @ ime

   ;; 標準IMEの設定
   ;; (setq default-input-method "anthy")
   (require 'mozc)
   (set-language-environment "Japanese")
   (setq default-input-method "japanese-mozc")

   ;; IME状態のモードライン表示
   ;; (setq-default w32-ime-mode-line-state-indicator "[Aa]")
   ;; (setq w32-ime-mode-line-state-indicator-list '("[Aa]" "[あ]" "[Aa]"))

   ;; IMEの初期化
   ;; (load-library "anthy")

   ;; IME OFF時の初期カーソルカラー
   (set-cursor-color "green")

   ;; IME ON/OFF時のカーソルカラー
   (add-hook 'input-method-activate-hook
              (lambda() (set-cursor-color "red")))
   (add-hook 'input-method-inactivate-hook
              (lambda() (set-cursor-color "green")))

   ;; バッファ切り替え時にIME状態を引き継ぐ
   ;; (setq w32-ime-buffer-switch-p nil)

;; ------------------------------------------------------------------------
;; @ frame
(set-face-attribute 'default nil
		    ;;:family "Menlo" ;; font 
		    :height 110) ;; font size

;; ------------------------------------------------------------------------
;; @ frame

   ;; フレームタイトルの設定
   (setq frame-title-format "%b")

;; ------------------------------------------------------------------------
;; @ buffer

   ;; バッファ画面外文字の切り詰め表示
   (setq truncate-lines nil)

   ;; ウィンドウ縦分割時のバッファ画面外文字の切り詰め表示
   (setq truncate-partial-width-windows t)

   ;; 同一バッファ名にディレクトリ付与
   (require 'uniquify)
   (setq uniquify-buffer-name-style 'forward)
   (setq uniquify-buffer-name-style 'post-forward-angle-brackets)
   (setq uniquify-ignore-buffers-re "*[^*]+*")

;; ------------------------------------------------------------------------
;; @ fringe

   ;; バッファ中の行番号表示
   (global-linum-mode t)

   ;; 行番号のフォーマット
   ;; (set-face-attribute 'linum nil :foreground "red" :height 0.8)
   (set-face-attribute 'linum nil :height 0.8)
   (setq linum-format "%4d")

;; ------------------------------------------------------------------------
;; @ modeline

   ;; 行番号の表示
   (line-number-mode t)

   ;; 列番号の表示
   (column-number-mode t)

   ;; 時刻の表示
   (require 'time)
   (setq display-time-24hr-format t)
   (setq display-time-string-forms '(24-hours ":" minutes))
   (display-time-mode t)

;; ------------------------------------------------------------------------
;; @ cursor

   ;; カーソル点滅表示
   (blink-cursor-mode 0)

   ;; スクロール時のカーソル位置の維持
   (setq scroll-preserve-screen-position t)

   ;; スクロール行数（一行ごとのスクロール）
   (setq vertical-centering-font-regexp ".*")
   (setq scroll-conservatively 35)
   (setq scroll-margin 0)
   (setq scroll-step 1)

   ;; 画面スクロール時の重複行数
   (setq next-screen-context-lines 1)

;; ------------------------------------------------------------------------
;; @ default setting

   ;; 起動メッセージの非表示
   (setq inhibit-startup-message t)

   ;; スタートアップ時のエコー領域メッセージの非表示
   (setq inhibit-startup-echo-area-message -1)

;; ------------------------------------------------------------------------
;; @ backup

   ;; 変更ファイルのバックアップ
   (setq make-backup-files nil)

   ;; 変更ファイルの番号つきバックアップ
   (setq version-control nil)

   ;; 編集中ファイルのバックアップ
   (setq auto-save-list-file-name nil)
   (setq auto-save-list-file-prefix nil)

   ;; 編集中ファイルのバックアップ先
   (setq auto-save-file-name-transforms
         `((".*" ,temporary-file-directory t)))

   ;; 編集中ファイルのバックアップ間隔（秒）
   (setq auto-save-timeout 30)

   ;; 編集中ファイルのバックアップ間隔（打鍵）
   (setq auto-save-interval 500)

   ;; バックアップ世代数
   (setq kept-old-versions 1)
   (setq kept-new-versions 2)

   ;; 上書き時の警告表示
   ;; (setq trim-versions-without-asking nil)

   ;; 古いバックアップファイルの削除
   (setq delete-old-versions t)

;; ------------------------------------------------------------------------
;; @ key bind

   ;; 標準キーバインド変更
   (global-set-key "\C-z"          'scroll-down)

;; ------------------------------------------------------------------------
;; @ scroll

   ;; バッファの先頭までスクロールアップ
   (defadvice scroll-up (around scroll-up-around)
     (interactive)
     (let* ( (start_num (+ 1 (count-lines (point-min) (point))) ) )
       (goto-char (point-max))
       (let* ( (end_num (+ 1 (count-lines (point-min) (point))) ) )
         (goto-line start_num )
         (let* ( (limit_num (- (- end_num start_num) (window-height)) ))
           (if (< (- (- end_num start_num) (window-height)) 0)
               (goto-char (point-max))
             ad-do-it)) )) )
   (ad-activate 'scroll-up)

   ;; バッファの最後までスクロールダウン
   (defadvice scroll-down (around scroll-down-around)
     (interactive)
     (let* ( (start_num (+ 1 (count-lines (point-min) (point)))) )
       (if (< start_num (window-height))
           (goto-char (point-min))
         ad-do-it) ))
   (ad-activate 'scroll-down)

;; -------------------------------------------------------------------------------
;; auto compleat
(require 'auto-complete)
(require 'auto-complete-config)
(global-auto-complete-mode t)

;; -------------------------------------------------------------------------------
;; cc-mode style(C,C++,Java,Objective-C)
(add-hook 'c-mode-common-hook
	  '(lambda()
	     (c-set-style "stroustrup")
	     (c-set-offset 'inline-open 0)
	     (setq c-basic-offset 4)
	     (setq tab-width c-basic-offset)
	     (setq c-auto-newline t)))

;; SQL
(add-hook 'sqql-mode-hook
	  '(lambda()
	     (setq sql-indent-offset 4)
	     (setq sql-indent-maybe-tab t)
	     (setq sql-tab-width 4)))

;; Window間の移動を矢印キーで行う。
(windmove-default-keybindings)
(setq windmove-wrap-around t)

;;; Frame parameters
(setq default-frame-alist
      (append '((foreground-color . "white")
		(background-color . "gray15")
		(mouse-color . "white")
		(cursor-color . "green")
		(vertical-scroll-bars . nil) ;;スクロールバーはいらない
		(width . 160)
		(height . 55)
		(left . 350)
		(vertical-scroll-bars . right)
		(line-spacing . 0)
		(cursor-type . box))
	      default-frame-alist))

(setq initial-frame-alist default-frame-alist)

