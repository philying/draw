package com.anjuke.view.component {
	import org.aswing.Component;
	import org.aswing.Container;
	import org.aswing.FlowLayout;
	import org.aswing.JButton;
	import org.aswing.JComboBox;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.JTextArea;
	import org.aswing.JTextField;
	import org.aswing.SoftBoxLayout;

	/**
	 * @author phil
	 */
	public class CreateTextPane extends JPanel {

		private var inputText : JTextArea;
		private var okButton : JButton;
		private var cancelButton : JButton;

		private var defaulttextCombo : JComboBox;

		public function CreateTextPane():void {
			super();
			inputText = new JTextArea("", 3, 20);
			//defaulttextCombo = new JComboBox();
			okButton = new JButton("确定");
			cancelButton = new JButton("取消");
			setLayout(new SoftBoxLayout(SoftBoxLayout.Y_AXIS, 2));
			//append(labelHold(defaulttextCombo, "选择文字:"));
			append(labelHold(inputText, "输入文字"));
			var buttonPane : JPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 16, 5));
			buttonPane.appendAll(okButton, cancelButton);
			append(buttonPane);
		}
		
		public function getOkButton():JButton{
			return this.okButton;
		}
		
		public function getCancelButton():JButton{
			return this.cancelButton;
		}
		
		public function getInputText():JTextArea{
			return this.inputText;
		}

		//创建一个容器,左边显示一个指定字符串text的标签,右边显示指定组件c,
		//通过toolTip指定需要显示的提示文字,如果不需要,则传入null
		private function labelHold(c : Component, text : String,toolTip : String = null) : Container {

			var panel : JPanel = new JPanel(new FlowLayout(FlowLayout.LEFT, 2, 0, false));
			var label : JLabel = new JLabel(text);
			panel.appendAll(label, c);
			if(toolTip != null) {
				panel.setToolTipText(toolTip);
			}
			return panel;
		}
		
	}
}
