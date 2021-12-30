import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seeds/i18n/profile_screens/profile/profile.i18n.dart';
import 'package:seeds/screens/profile_screens/profile/components/edit_profile_pic_bottom_sheet/interactor/viewmodels/pick_image_bloc.dart';

class EditProfilePicBottomSheet extends StatelessWidget {
  const EditProfilePicBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PickImageBloc(),
      child: BlocConsumer<PickImageBloc, PickImageState>(
        listenWhen: (previous, current) => previous.file != current.file,
        listener: (context, state) {
          // When the system explore files is open or the camera is open, the wallet app
          // goes into the background (paused) and this triggers the verification screen.
          // thus, we need fire an extra pop.
          Navigator.of(context).pop(); // <--- to remove verify screen
          Navigator.of(context).pop(state.file);
        },
        builder: (context, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: Text('Choose Picture'.i18n),
                onTap: () => BlocProvider.of<PickImageBloc>(context).add(const GetImage(source: ImageSource.gallery)),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text('Take a picture'.i18n),
                onTap: () => BlocProvider.of<PickImageBloc>(context).add(const GetImage(source: ImageSource.camera)),
              ),
            ],
          );
        },
      ),
    );
  }
}
