package common.debug
{

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.system.System;
    import flash.text.TextField;
    import flash.text.TextFieldType;
    import flash.text.TextFormat;
    import flash.ui.Keyboard;

    public class DLogViewer extends Sprite implements IDLogAppender
    {
        protected var _messageQueue : Array = [];
        protected var _maxLength : uint = 200000;
        protected var _truncating : Boolean = false;

        protected var _width : uint = 500;
        protected var _height : uint = 150;

        protected var _consoleHistory : Array = [];
        protected var _historyIndex : uint = 0;

        protected var _outputBitmap : Bitmap = new Bitmap(new BitmapData(640, 480, false, 0x0));
        protected var _input : TextField;

        protected var tabCompletionPrefix : String = "";
        protected var tabCompletionCurrentStart : int = 0;
        protected var tabCompletionCurrentEnd : int = 0;
        protected var tabCompletionCurrentOffset : int = 0;

        protected var glyphCache : GlyphCache = new GlyphCache();

        protected var bottomLineIndex : int = int.MAX_VALUE;
        protected var logCache : Array = [];
        protected var _dirtyConsole : Boolean = true;

        public function DLogViewer() : void
        {
            layout();
            addListeners();

            name = "Console";
            DConsole.registerCommand("copy", onBitmapDoubleClick, "复制日志内容到粘贴板.");
            DConsole.registerCommand("clear", onClearCommand, "清除日志.");
        }

        protected function layout() : void
        {
            if ( !_input ) createInputField();

            resize();

            _outputBitmap.name = "ConsoleOutput";
            addEventListener(MouseEvent.CLICK, onBitmapClick);
            addEventListener(MouseEvent.DOUBLE_CLICK, onBitmapDoubleClick);
            addEventListener(Event.ENTER_FRAME, onFrame);

            addChild(_outputBitmap);
            addChild(_input);

            graphics.clear();
            graphics.beginFill(0x000000, .6);
            graphics.drawRect(0, 0, _width + 1, _height + 5);
            graphics.endFill();

            // Necessary for click listeners.
            mouseEnabled = true;
            doubleClickEnabled = true;

            _dirtyConsole = true;
        }

        protected function addListeners() : void
        {
            _input.addEventListener(KeyboardEvent.KEY_DOWN, onInputKeyDown, false, 1, true);
        }

        protected function removeListeners() : void
        {
            _input.removeEventListener(KeyboardEvent.KEY_DOWN, onInputKeyDown);
        }

        protected function onBitmapClick(me : MouseEvent) : void
        {
            // Give focus to input.
            this.stage.focus = _input;
        }

        protected function onBitmapDoubleClick(me : MouseEvent = null) : void
        {
            // Put everything into a monster string.
            var logString : String = "";
            for ( var i : int = 0; i < logCache.length; i++ )
                logString += logCache[i].text + "\n";

            // Copy content.
            System.setClipboard(logString);

            Logger.print(this, "复制日志内容到粘贴板.");
        }

        /**
         * Wipe the displayed console output.
         */
        protected function onClearCommand() : void
        {
            logCache = [];
            bottomLineIndex = -1;
            _dirtyConsole = true;
        }

        protected function resize() : void
        {
            _outputBitmap.x = 5;
            _outputBitmap.y = 0;
            _input.x = 5;

            if ( stage )
            {
                _width = stage.stageWidth - 1;
                _height = stage.stageHeight / 2;
            }

            // Resize display surface.
            _outputBitmap.bitmapData.dispose();
            _outputBitmap.bitmapData = new BitmapData(_width - 10, _height - 30, true, 0x0);

            _input.height = 20;
            _input.width = _width - 10;

            _input.y = _outputBitmap.height + 10;

            _dirtyConsole = true;
        }

        protected function createInputField() : TextField
        {
            _input = new TextField();
            _input.type = TextFieldType.INPUT;
            _input.border = true;
            _input.borderColor = 0xCCCCCC;
            _input.multiline = false;
            _input.wordWrap = false;
            _input.condenseWhite = false;
            var format : TextFormat = _input.getTextFormat();
            format.font = "Arial";
            format.size = 14;
            format.color = 0xFFFFFF;
            _input.setTextFormat(format);
            _input.defaultTextFormat = format;
            _input.name = "ConsoleInput";

            return _input;
        }

        protected function setHistory(old : String) : void
        {
            _input.text = old;
        }

        protected function onInputKeyDown(event : KeyboardEvent) : void
        {
            // If this was a non-tab input, clear tab completion state.
            if ( event.keyCode != Keyboard.TAB && event.keyCode != Keyboard.SHIFT )
            {
                tabCompletionPrefix = _input.text;
                tabCompletionCurrentStart = -1;
                tabCompletionCurrentOffset = 0;
            }

            if ( event.keyCode == Keyboard.ENTER )
            {
                // Execute an entered command.
                if ( _input.text.length <= 0 )
                {
                    // display a blank line
                    addLogMessage("CMD", ">", _input.text);
                    return;
                }

                // If Enter was pressed, process the command
                processCommand();
            }
            else if ( event.keyCode == Keyboard.UP )
            {
                // Go to previous command.
                if ( _historyIndex > 0 )
                {
                    setHistory(_consoleHistory[--_historyIndex]);
                }
                else if ( _consoleHistory.length > 0 )
                {
                    setHistory(_consoleHistory[0]);
                }

                event.preventDefault();
            }
            else if ( event.keyCode == Keyboard.DOWN )
            {
                // Go to next command.
                if ( _historyIndex < _consoleHistory.length - 1 )
                {
                    setHistory(_consoleHistory[++_historyIndex]);
                }
                else if ( _historyIndex == _consoleHistory.length - 1 )
                {
                    _input.text = "";
                }

                event.preventDefault();
            }
            else if ( event.keyCode == Keyboard.PAGE_UP )
            {
                // Page the console view up.
                if ( bottomLineIndex == int.MAX_VALUE )
                    bottomLineIndex = logCache.length - 1;

                bottomLineIndex -= getScreenHeightInLines() - 2;

                if ( bottomLineIndex < 0 )
                    bottomLineIndex = 0;
            }
            else if ( event.keyCode == Keyboard.PAGE_DOWN )
            {
                // Page the console view down.
                if ( bottomLineIndex != int.MAX_VALUE )
                {
                    bottomLineIndex += getScreenHeightInLines() - 2;

                    if ( bottomLineIndex + getScreenHeightInLines() >= logCache.length )
                        bottomLineIndex = int.MAX_VALUE;
                }
            }
            else if ( event.keyCode == Keyboard.TAB )
            {
                // We are doing tab searching.
                var list : Array = DConsole.getCommandList();

                // Is this the first step?
                var isFirst : Boolean = false;
                if ( tabCompletionCurrentStart == -1 )
                {
                    tabCompletionPrefix = _input.text.toLowerCase();
                    tabCompletionCurrentStart = int.MAX_VALUE;
                    tabCompletionCurrentEnd = -1;

                    for ( var i : int = 0; i < list.length; i++ )
                    {
                        // If we found a prefix match...
                        if ( (list[i].name.substr(0, tabCompletionPrefix.length) as String).toLowerCase() == tabCompletionPrefix )
                        {
                            // Note it.
                            if ( i < tabCompletionCurrentStart )
                                tabCompletionCurrentStart = i;
                            if ( i > tabCompletionCurrentEnd )
                                tabCompletionCurrentEnd = i;

                            isFirst = true;
                        }
                    }

                    tabCompletionCurrentOffset = tabCompletionCurrentStart;
                }

                // If there is a match, tab complete.
                if ( tabCompletionCurrentEnd != -1 )
                {
                    // Update offset if appropriate.
                    if ( !isFirst )
                    {
                        if ( event.shiftKey )
                            tabCompletionCurrentOffset--;
                        else
                            tabCompletionCurrentOffset++;

                        // Wrap the offset.
                        if ( tabCompletionCurrentOffset < tabCompletionCurrentStart )
                        {
                            tabCompletionCurrentOffset = tabCompletionCurrentEnd;
                        }
                        else if ( tabCompletionCurrentOffset > tabCompletionCurrentEnd )
                        {
                            tabCompletionCurrentOffset = tabCompletionCurrentStart;
                        }
                    }

                    // Get the match.
                    var potentialMatch : String = list[tabCompletionCurrentOffset].name;

                    // Update the text with the current completion, caret at the end.
                    _input.text = potentialMatch;
                    _input.setSelection(potentialMatch.length + 1, potentialMatch.length + 1);
                }

                // Make sure we keep focus. TODO: This is not ideal, it still flickers the yellow box.
                var oldfr : * = stage.stageFocusRect;
                stage.stageFocusRect = false;
            }
            else if ( event.keyCode == DConsole.hotKeyCode )
            {
                // Hide the console window, have to check here due to 
                // propagation stop at end of function.
//                parent.removeChild(this);
                y = -this.height;
//				Tweener.removeTweens(this);
//				Tweener.addTween(this,{time:.4,transition:Equations.easeOutExpo,y:-this.height,onComplete:onTweenComplete});
                deactivate();
            }

            _dirtyConsole = true;

            // Keep console input from propagating up to the stage and messing up the game.
            event.stopImmediatePropagation();
        }

        private function onTweenComplete() : void
        {
            parent.removeChild(this);
        }

        protected function processCommand() : void
        {
            addLogMessage("CMD", ">", _input.text);
            DConsole.processLine(_input.text);
            _consoleHistory.push(_input.text);
            _historyIndex = _consoleHistory.length;
            _input.text = "";

            _dirtyConsole = true;
        }

        public function getScreenHeightInLines() : int
        {
            var roundedHeight : int = _outputBitmap.bitmapData.height;
            return Math.floor(roundedHeight / glyphCache.getLineHeight());
        }

        public function onFrame(evt : Event) : void
        {
            // Don't draw if we are clean or invisible.
            if ( _dirtyConsole == false || parent == null )
                return;
            _dirtyConsole = false;

            // Figure our visible range.
            var lineHeight : int = getScreenHeightInLines() - 1;
            var startLine : int = 0;
            var endLine : int = 0;
            if ( bottomLineIndex == int.MAX_VALUE )
                startLine = PBUtil.clamp(logCache.length - lineHeight, 0, int.MAX_VALUE);
            else
                startLine = PBUtil.clamp(bottomLineIndex - lineHeight, 0, int.MAX_VALUE);

            endLine = PBUtil.clamp(startLine + lineHeight, 0, logCache.length - 1);

            startLine--;

            // Wipe it.清除bitmapData数据
            var bd : BitmapData = _outputBitmap.bitmapData;
            bd.fillRect(bd.rect, 0x0);

            // Draw lines.
            for ( var i : int = endLine; i >= startLine; i-- )
            {
                // Skip empty.
                if ( !logCache[i] )
                    continue;

                glyphCache.drawLineToBitmap(logCache[i].text, 0, _outputBitmap.height - (endLine + 1 - i) * glyphCache.getLineHeight() - 3, logCache[i].color, _outputBitmap.bitmapData);
            }
        }

        public function addLogMessage(level : String, loggerName : String, message : String) : void
        {
            var color : String = DLogColor.getColor(level);

            // Cut down on the logger level if verbosity requests.
            if ( DConsole.verbosity < 2 )
            {
                var dotIdx : int = loggerName.lastIndexOf("::");
                if ( dotIdx != -1 )
                    loggerName = loggerName.substr(dotIdx + 2);
            }

            // Split message by newline and add to the list.
            var messages : Array = message.split("\n");
            for each ( var msg : String in messages )
            {
                var text : String = ((DConsole.verbosity > 0) ? level + ": " : "") + loggerName + " - " + msg;
                logCache.push({"color": parseInt(color.substr(1), 16), "text": text});
            }

            _dirtyConsole = true;
        }

        public function activate() : void
        {
            layout();
            _input.text = "";
            addListeners();
        }

        public function deactivate() : void
        {
            removeListeners();
        }

        public function set restrict(value : String) : void
        {
            _input.restrict = value;
        }

        public function get restrict() : String
        {
            return _input.restrict;
        }
    }
}
