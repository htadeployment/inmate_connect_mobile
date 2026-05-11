import 'dart:typed_data';
import 'package:flutter/material.dart';

class MediaCaptureTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Uint8List? imageBytes;
  final VoidCallback onTap;

  const MediaCaptureTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageBytes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blueGrey.shade100),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const Icon(Icons.camera_alt_outlined, size: 20),
                ],
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 12),
              AspectRatio(
                aspectRatio: 1.7,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageBytes == null
                      ? Container(
                          color: Colors.white,
                          child: const Center(
                            child: Icon(Icons.add_a_photo_outlined, size: 36, color: Colors.blueGrey),
                          ),
                        )
                      : Image.memory(imageBytes!, fit: BoxFit.cover),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
