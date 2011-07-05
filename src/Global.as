package  
{
	/**
	 * Global class store all the default configuration and runtime settings.
	 */
	public class Global
	{
		public static var runtime:Object = {
				isSWF : 					false, /* true if SWF JSON data */
				showShapeRecord :			false,
				mouseOverScaling :			false,				
				showRows		:			true
		};

		/**
		 * Static object to store all the default settings.
		 */
		public static const config:Object = {
			__TYPE_INFO__ : "config",
			system : {
				__TYPE_INFO__ : "system",
				swf2jsonURL : 			"http://rintarou.dyndns.org/tests/swf2json.php?swfURL=",
				uploadswf2jsonURL :		"http://rintarou.dyndns.org/tests/uploadswf2json.php",
				textColor : 			0x999999,
				textFormat : {
					font : 				"Arial",
					size : 				14,
					color : 			0x666666, //0x393b3b
					bold : 				true,
					leftMargin :		5,
					rightMargin :		5
				},
				JSON_OBJECT_TYPE_INFO :	"__TYPE_INFO__"				
			},
			
			layout : {
				__TYPE_INFO__ : "layout",
				colSpace :				550,
				rowSpace :				20
			},
			
			tooltip : {
				__TYPE_INFO__ : "tooltip",
				textColor : 			0xffffff,
				bodyBackgroundColor : 	0x242322,
				alpha :					0.65,
				showTime :				0.5
			},
			
			toolbox : {
				__TYPE_INFO__ : "toolbox",
				title : 				"SWFVisualizer 0.3.2",
				titleColor : 			0x999999,
				titleBackgroundColor : 	0x242322,
				bodyBackgroundColor : 	0x171615, //0x242322,
				width :					230,
				height :				90
			},
			
			jsonbox : {
				__TYPE_INFO__ : "jsonbox",
				title : 				"JSON Visualization",
				titleColor : 			0x999999,
				titleBackgroundColor : 	0x242322,
				bodyBackgroundColor : 	0x171615, //0x242322,
				width :					300,
				height :				200,
				left :					250
			},

			infobox : {
				__TYPE_INFO__ : "infobox",
				backgroundColor : 		0x171615,
				borderColor : 			0x393837,
				defaultTextHeight : 	19
			},
			
			table : {
				__TYPE_INFO__ : "table",
				
				/* templates */
				normal : {
					__TYPE_INFO__ : "Normal",
					header : {
						__TYPE_INFO__ : "header",
						backgroundColor :  	0x0B347E, //0xEF320F, //0x393b3b,
						height : 			20,
						textColor :  		0xA4A5A1,
						borderColor : 		0x4a4d4c,
						borderThickness : 	0
					},
					body : {
						__TYPE_INFO__ : "body",
						backgroundColor :  	0x242322, //0x242322,
						textColor :  		0x666666,
						borderColor : 		0x009CF3,
						borderThickness : 	0
					},
					link : {
						__TYPE_INFO__ : "link",
						lineThickness : 1,
						activatedLineColor : 0xaaaaaa,
						lineColor : 0x0B347E
					}
				},
				
				defineShape : {
					__TYPE_INFO__ : "DefineShape",
					header : {
						__TYPE_INFO__ : "header",
						backgroundColor :  	0xC0560E, //0xF0860E, //0x05F2CB, //0x00aa00,
						height : 			20,
						textColor :  		0x999999,
						borderColor : 		0x4a4d4c,
						borderThickness : 	0
					},
					body : {
						__TYPE_INFO__ : "body",
						backgroundColor :  	0x242322,
						textColor :  		0x666666,
						borderColor : 		0x06020F,
						borderThickness : 	0
					},
					link : {
						__TYPE_INFO__ : "link",
						lineThickness : 1,
						activatedLineColor : 0xaaaaaa,
						lineColor : 0xC0560E
					}
				},
				
				shapeWithStyle : {
					__TYPE_INFO__ : "ShapeWithStyle",
					header : {
						__TYPE_INFO__ : "header",
						backgroundColor :  	0xA23139, //0xD24169, //0xF2CB05,
						height : 			20,
						textColor :  		0x999999,
						borderColor : 		0x4a4d4c,
						borderThickness : 	0
					},
					body : {
						__TYPE_INFO__ : "body",
						backgroundColor :  	0x242322,
						textColor :  		0x666666,
						borderColor : 		0x06020F,
						borderThickness : 	0
					},
					link : {
						__TYPE_INFO__ : "link",
						lineThickness : 1,
						activatedLineColor : 0xaaaaaa,
						lineColor : 0xA23139 //0x328B40
					}
				},
				
				shape : {
					__TYPE_INFO__ : "Shape",
					header : {
						__TYPE_INFO__ : "header",
						backgroundColor :  	0xB29705, //0x05cbf2, //0x0385ba, //0x920c1d,
						height : 			20,
						textColor :  		0x999999,
						borderColor : 		0x4a4d4c,
						borderThickness : 	0
					},
					body : {
						__TYPE_INFO__ : "body",
						backgroundColor :  	0x242322,
						textColor :  		0x666666,
						borderColor : 		0x06020F,
						borderThickness : 	0
					},
					link : {
						__TYPE_INFO__ : "link",
						lineThickness : 1,
						activatedLineColor : 0xaaaaaa,
						lineColor : 0xB29705
					}
				},
				
				
				colors : {
					__TYPE_INFO__ : "Colors",
					header : {
						__TYPE_INFO__ : "header",
						backgroundColor :  	0x0B347E, //0x81B477, //0x3a96c1,
						height : 			20,
						textColor :  		0x999999,
						borderColor : 		0x4a4d4c,
						borderThickness : 	0
					},
					body : {
						__TYPE_INFO__ : "body",
						backgroundColor :  	0x242322,
						textColor :  		0x666666,
						borderColor : 		0x06020F,
						borderThickness : 	0
					},
					link : {
						__TYPE_INFO__ : "link",
						lineThickness : 1,
						activatedLineColor : 0xaaaaaa,
						lineColor : 0x0B347E
					}
				},
				
				edges : {
					__TYPE_INFO__ : "Edges",
					header : {
						__TYPE_INFO__ : "Header",
						backgroundColor :  	0x0385ba,
						height : 			20,
						textColor :  		0x999999,
						borderColor : 		0x4a4d4c,
						borderThickness : 	0
					},
					body : {
						__TYPE_INFO__ : "body",
						backgroundColor :  	0x242322,
						textColor :  		0x666666,
						borderColor : 		0x06020F,
						borderThickness : 	0
					},
					link : {
						__TYPE_INFO__ : "link",
						lineThickness : 1,
						activatedLineColor : 0xaaaaaa,
						lineColor : 0x0385ba
					}
				},
				
				geometry : {
					__TYPE_INFO__ : "Geometry",
					header : {
						__TYPE_INFO__ : "Header",
						backgroundColor :  	0x393b3b,
						height : 			20,
						textColor :  		0x999999,
						borderColor : 		0x4a4d4c,
						borderThickness : 	0
					},
					body : {
						__TYPE_INFO__ : "body",
						backgroundColor :  	0x242322,
						textColor :  		0x666666,
						borderColor : 		0x06020F,
						borderThickness : 	0
					},
					link : {
						__TYPE_INFO__ : "link",
						lineThickness : 1,
						activatedLineColor : 0xffffff,
						lineColor : 0x393b3b
					}
				}
			}
			
		};
		
	}
}