import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/route/app_route.dart';
import 'package:social_media_app/modules/post/bloc/post_bloc.dart';
import 'package:social_media_app/modules/post/model/post_model.dart';
import 'package:social_media_app/utils/message_dialog.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
              return TextButton(onPressed: state.store.isLoading ? null : (){
                context.read<PostBloc>().createPostEvent();
              }, child:state.store.isLoading ? CircularProgressIndicator() : Text('Post',style: TextStyle(color: Colors.white),));
            }
          ),
        ],
      ),
      body: BlocConsumer<PostBloc, PostState>(
        listener: (context,state){
          switch(state){
            case PostCreated():
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
                duration: const Duration(seconds: 1),
              ));
              context.pop();
            case PostError():
              showMessageDialog(context: context, message: state.error);
            default:
          }
        },
        builder: (context, state) {
          final store = state.store;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  initialValue: store.title,
                  decoration: const InputDecoration(
                    hintText: 'Post title...',
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  onChanged: (v) => context.read<PostBloc>().setPostTextEvent(title: v),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: store.body,
                    decoration: const InputDecoration(
                      hintText: "What's on your mind?",
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 16),
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    onChanged: (v) => context.read<PostBloc>().setPostTextEvent(body: v),
                  ),
                ),
                _buildMediaSection(store),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMediaSection(PostStore store) {
    // final selectedImages = store.selectedMedia.where((m) => m.type == MediaType.image).toList();
    // final selectedVideos = store.selectedMedia.where((m) => m.type == MediaType.video).toList();
    final hasMedia = store.selectedMedia.isNotEmpty;
    final isProcessing = store.isLoading;

    return Column(
      children: [
        if (hasMedia) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: store.selectedMedia.length,
              itemBuilder: (context, index) {
                final media = store.selectedMedia[index];
                return media.type == MediaType.image
                    ? _buildImagePreview(media.url, index)
                    : _buildVideoPreview(media.url, index);
              },
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (isProcessing) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 8),
              Text(
                'Processing media...',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        Row(
          children: [
            IconButton(
              onPressed: isProcessing ? null : () async{
                final mediaList = await GoRouter.of(context).push<List<MediaModel>>(AppRouter.galleryPage);
                context.read<PostBloc>().addMediaEvent(mediaList ?? []);
              },
              icon: Icon(Icons.file_copy, color: isProcessing ? Colors.grey : Colors.blue),
              tooltip: 'Add File',
            ),
            if (hasMedia) ...[
              const Spacer(),
              IconButton(
                onPressed: isProcessing ? null : () => context.read<PostBloc>().removeMediaEvent(removeAll: true),
                icon: Icon(Icons.clear_all, color: isProcessing ? Colors.grey : Colors.red),
                tooltip: 'Clear All Media',
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildImagePreview(String path, int index) {
    return Container(
      width: 120,
      height: 120,
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(path),
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: GestureDetector(
              onTap: () => context.read<PostBloc>().removeMediaEvent(index:index),
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPreview(String path, int index) {
    return Container(
      width: 120,
      height: 120,
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            color: Colors.grey[300],
            child: const Icon(Icons.videocam, size: 40, color: Colors.grey),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: GestureDetector(
              onTap: () => context.read<PostBloc>().removeMediaEvent(index:index),
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
