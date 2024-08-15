import 'package:flutter/material.dart';
import 'package:pairsonic/features/profile/identity_service.dart';
import 'package:pairsonic/features/profile/user_model.dart';
import 'package:pairsonic/generated/l10n.dart';
import 'package:pairsonic/helper/gui_utility_interface.dart';
import 'package:pairsonic/service_locator.dart';

/// A Screen to display the address book.
///
/// {@category Screens}
class AddressBookScreen extends StatefulWidget {
  const AddressBookScreen({super.key});

  @override
  State<AddressBookScreen> createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> {
  final _localDatabaseService = getIt<GuiUtilityInterface>();
  final _identityService = getIt<IdentityService>();

  String _id = "";

  @override
  void initState() {
    _identityService.deviceId.then((value) => _id = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).contacts),
      ),
      body: FutureBuilder<List<User>>(
        future: _localDatabaseService.getAllUser(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.length == 1) {
              //Only own profile
              return SizedBox(
                height: double.infinity,
                child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ListTile(title: Text(S.of(context).noContacts))),
              );
            } else {
              // Remove own profile
              snapshot.data!.removeWhere((element) => element.id == _id);
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    User u = snapshot.data![index];
                    return Card(
                      child: ListTile(
                        onTap: () => {},
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      u.verified ? Colors.green : Colors.red,
                                  width: 3.0,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: ExactAssetImage(u.iconPath),
                              ),
                            ),
                          ],
                        ),
                        title: Text(u.name),
                        subtitle: Text(u.bio, maxLines: 2),
                      ),
                    );
                  });
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }),
    );
  }
}
