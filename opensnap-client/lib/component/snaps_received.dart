part of opensnap;

@NgComponent(
    selector: 'snaps-received',
    templateUrl: 'packages/opensnap/component/snaps_received.html',
    cssUrl: 'packages/opensnap/component/snaps_received.css',
    applyAuthorStyles: true,
    publishAs: 'ctrl'
)
class SnapsReceivedComponent {
  
  ImageElement photo;
  DivElement photoGroup;
  DivElement progress;
  
  SnapService _snapService;
  UserService _userService;
  Router _router;

  int progressValue;
  int maxValue;
  
  bool displayPhoto = false;
  String imgData = "";
  
  bool get hasSnaps => !this._snapService.snapsReceived.isEmpty;
  List<Snap> get snaps => this._snapService.snapsReceived;
  bool get hasImgData => !this.imgData.isEmpty;
  
  SnapsReceivedComponent(this._snapService, this._userService, this._router) {
    if(!_userService.isAuthenticated) {
      _router.go('signin', new Map());
      return;
    }
  }
  
  void viewSnap(Snap partialSnap) {
    // Retreive full snap with photo
    _snapService.getSnapById(partialSnap.id).then((Snap s) {
      imgData = s.photo;
      maxValue = s.duration * 1000;
      progressValue=10;
      displayPhoto = true;
      new Timer.periodic(new Duration(milliseconds: 10), (Timer t) {
        if(progressValue > s.duration * 1000) {
          _snapService.deleteSnap(s);
          snaps.remove(s);
          displayPhoto = false;
          imgData = "";
          t.cancel();
        }
        progressValue = progressValue + 10;
      });
    });
  }
  
}