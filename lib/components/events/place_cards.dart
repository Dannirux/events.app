import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_moviles/extensions/text_theme_x.dart';
import 'package:project_moviles/models/event.dart';

import '../../models/place.dart';
import 'gradient_status_tag.dart';

class PlaceCard extends StatelessWidget {
  final Event event;
  final VoidCallback onPressed;

  const PlaceCard({
    super.key,
    required this.event,
    required this.onPressed,
  });

  BoxDecoration get _cardDecoration {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      image: DecorationImage(
        image: CachedNetworkImageProvider(event.images.first),
        fit: BoxFit.cover,
        colorFilter: const ColorFilter.mode(
          Colors.black26,
          BlendMode.darken,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusTag = event.name;
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _UserInformationRow(university: event.university),
            const Spacer(),
            Text(event.name, style: context.bodyText1.copyWith(
              color: Colors.white,
            ),),
            const SizedBox(height: 10),
            GradientStatusTag(type: 'event'),
            const Spacer(),
            _ActionButtons(event: event)
          ],
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton.icon(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            shape: const StadiumBorder(),
          ),
          icon: const Icon(CupertinoIcons.heart),
          label: Text('310'),
        ),
        TextButton.icon(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            shape: const StadiumBorder(),
          ),
          icon: const Icon(CupertinoIcons.reply),
          label: Text('420'),
        )
      ],
    );
  }
}

class _UserInformationRow extends StatelessWidget {
  final String university;
  const _UserInformationRow({required this.university});


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: CachedNetworkImageProvider('https://aka-cdn.uce.edu.ec/ares/tmp/SIIU/anuncios/sello_400.png'),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              university,
              style: context.bodyText1.copyWith(
                color: Colors.white,
              ),
            ),
            Text(
              'yesterday at 9:10 p.m.',
              style: context.bodyText1.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () {

          },
          icon: const Icon(
            Icons.more_horiz,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}