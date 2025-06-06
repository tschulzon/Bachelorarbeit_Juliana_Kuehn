import 'package:flutter/material.dart';

class BottomModal extends StatelessWidget {
  const BottomModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 275,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Text(
                'Aktivität hinzufügen',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.onPrimary,
              thickness: 2,
              height: 24,
              indent: 20,
              endIndent: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => debugPrint('Notiz erfassen tapped'),
                  splashColor:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.note_add,
                            size: 24,
                            color: Theme.of(context).colorScheme.onPrimary),
                        const SizedBox(width: 15),
                        Text('Notiz erfassen',
                            style: Theme.of(context).textTheme.displaySmall),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => debugPrint('Foto erfassen tapped'),
                  splashColor:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.add_a_photo,
                            size: 24,
                            color: Theme.of(context).colorScheme.onPrimary),
                        const SizedBox(width: 15),
                        Text('Foto aufnehmen',
                            style: Theme.of(context).textTheme.displaySmall),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => debugPrint('Zugeschnitten tapped'),
                  splashColor:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.content_cut,
                            size: 24,
                            color: Theme.of(context).colorScheme.onPrimary),
                        const SizedBox(width: 15),
                        Text('Zugeschnitten',
                            style: Theme.of(context).textTheme.displaySmall),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => debugPrint('Umgetopft tapped'),
                  splashColor:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.grass,
                            size: 24,
                            color: Theme.of(context).colorScheme.onPrimary),
                        const SizedBox(width: 15),
                        Text('Umgetopft',
                            style: Theme.of(context).textTheme.displaySmall),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
