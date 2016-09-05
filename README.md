# ASImagePicker
Highly imitate UIImagePickerController.Support for multiSelect, categories!(Use Photos Framework)

## Installation
```
pod ‘ASImagePicker’, '~> 0.0.1’
```

## Usage
### Initialize
```
ASImagePickerController *imagePicker = [[ASImagePickerController alloc] init];
```

### Access
```
imagePicker.access = ASImagePickerControllerAccessAlbums;
```

### Properties
```
imagePicker.showsEmptyAlbum = YES;
imagePicker.showsAlbumCategory = YES;
imagePicker.showsAlbumNumber = YES;
imagePicker.showsAlbumThumbImage = YES;
imagePicker.allowsMultiSelected = YES;
imagePicker.rowLimit = 4;
imagePicker.imageLimit = 3;
```

### Completion
```
imagePicker.completionBlock =  ^(NSArray<id> *datas, NSError *error) {
    //datas represent the selected images;    
};
```

### Modal Show
```
[self presentViewController:imagePicker animated:YES completion:nil];
```

## License
ASImagePicker is released under the MIT license. See LICENSE for details.