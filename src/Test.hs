import Graphics.UI.Gtk
import Graphics.UI.Gtk.ModelView as Model

-- main :: IO ()
-- main = return ()

main = do
   initGUI       -- is start
   window <- windowNew
   list <- listStoreNew ["Vince", "Jhen", "Chris", "Sharon"]
   treeview <- Model.treeViewNewWithModel list
   Model.treeViewSetHeadersVisible treeview True
           -- there should be a simpler way to render a list as the following!
   col <- Model.treeViewColumnNew
   Model.treeViewColumnSetTitle col "colTitle"
   renderer <- Model.cellRendererTextNew
   Model.cellLayoutPackStart col renderer False
   Model.cellLayoutSetAttributes col renderer list
           $ \ind -> [Model.cellText := ind]
   Model.treeViewAppendColumn treeview col
   tree <- Model.treeViewGetSelection treeview
   Model.treeSelectionSetMode tree  SelectionSingle
   Model.onSelectionChanged tree (oneSelection list tree)
   set window [ windowDefaultWidth := 100
               , windowDefaultHeight := 200
               , containerChild := treeview
              ]
   onDestroy window mainQuit
   widgetShowAll window
   mainGUI
   return ()
oneSelection :: ListStore String -> Model.TreeSelection ->  IO ()
oneSelection list tree = do
   sel <- Model.treeSelectionGetSelectedRows tree
   let s = head  (head sel)
   v <- Model.listStoreGetValue list s
   putStrLn $ "selected " ++ v
