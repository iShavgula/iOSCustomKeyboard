# iOSCustomKeyboard
Third-party custom keyboard for iOS (Georgian Layout)

Flexible way to generate iOS custom keyboards with different layouts.

- Keyboard model can be initialised from JSON, which means you can perform over the air updates to add new layouts or languagses.
- Different themes can be added as well (not fully implemented).
- Single instance of keyboard can be multi-language, each with it's own layout and content.


- To accelerate keyboard load time, no auto-layout is used. All frames are precalculated even before the keyboard appears.
  Takes couple of miliseconds. There is a template JSON as well as english layout defined programatically which illustrates 
  how to define frames, content and style preperly. Currently only 4.7 inch screen is supported but any resolution can be added easily.
  
  
  Todo: 
   - Finish implementing popups
     - Basic popup
     - Popup with input options
   - Add support for different key frame drawings
   - and much more...
