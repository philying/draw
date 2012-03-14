package com.anjuke.view.component {
	import flash.events.Event;
	import flash.net.URLRequest;

	import org.aswing.DefaultListCell;
	import org.aswing.*;
	import org.aswing.border.LineBorder;
	import org.aswing.geom.IntDimension;
	import org.aswing.dnd.*;
	import org.aswing.event.DragAndDropEvent;

	import com.anjuke.view.component.*;

	public class IconListCell implements ListCell {

		private var pane : JPanel;
		private var loadPane : JLoadPane;
		private var label : JLabel;
		private var value : SymbolSprit;
		//private var addbutton:JButton;

		public function IconListCell() {
			super();
			pane = new JPanel(new FlowLayout());
			loadPane = new JLoadPane();
			loadPane.setScaleMode(AssetPane.SCALE_NONE);
			//这里必须预先给loadPane设置期望大小
			loadPane.setPreferredSize(new IntDimension(100, 100));
			loadPane.addEventListener(Event.COMPLETE, _loadComplete);
			label = new JLabel();
			//addbutton = new JButton("添加");
			pane.append(loadPane);
			pane.append(label);
			//trace(loadPane.x + ","+label);
			//pane.append(addbutton);
			//pane.setBorder(new LineBorder());
			//设置为透明策略,为使不同状态不同背景色有效
			pane.setOpaque(true);
			label.setOpaque(false);
			//设置可拖拽
			loadPane.setDragEnabled(true);
			loadPane.addEventListener(DragAndDropEvent.DRAG_RECOGNIZED, _dragStart);
		}
		
		private function _dragStart(e : DragAndDropEvent) : void {
			//开始拖动，这里的SourceData实际上不会得到使用，
			//不过为了编译通过，我们依然创建了它
			DragManager.startDrag(e.target as JLoadPane, new SourceData("color", 0), new SymbolDragImage(e.getDragInitiator()));
		}

		private function _loadComplete(e : Event) : void {
			//图片加载完成后,调用此方法使图片得到布局
			loadPane.doLayout();
			loadPane.scaleX = 0.8;
			loadPane.scaleY = 0.8;
		}

		public function getCellValue() : * {
			return value;
		}		
		
		public function setCellValue(v : *) : void {
			value = SymbolSprit(v);
			loadPane.load(new URLRequest(value.getImage()));
			loadPane.name = value.getImage();
			label.setText(value.getLabel());
		}

		public   function  setListCellStatus(list : JList,  selected : Boolean,index : int) : void {

			if(selected) {
				pane.setBackground(list.getSelectionBackground());
				pane.setForeground(list.getSelectionForeground());
			} else {
				pane.setBackground(list.getBackground());
				pane.setForeground(list.getForeground());
			}
			label.setFont(list.getFont());
		}

		public function getCellComponent() : Component {
			return pane;
		}
	}
}
