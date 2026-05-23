import 'package:flutter/material.dart';
import '../services/xtream_service.dart';
import '../models/channel.dart';
import '../models/vod.dart';
import 'player_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Channel> _channels = [];
  List<VodItem> _vod = [];
  List<VodItem> _series = [];
  bool _loadingChannels = true;
  bool _loadingVod = true;
  bool _loadingSeries = true;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAll();
  }

  Future<void> _loadAll() async {
    final svc = XtreamService();
    final ch = await svc.getLiveChannels();
    setState(() { _channels = ch; _loadingChannels = false; });
    final vod = await svc.getVod();
    setState(() { _vod = vod; _loadingVod = false; });
    final ser = await svc.getSeries();
    setState(() { _series = ser; _loadingSeries = false; });
  }

  void _logout() {
    XtreamService().logout();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  void _playChannel(Channel ch) {
    final url = XtreamService().getLiveStreamUrl(ch.streamId);
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => PlayerScreen(title: ch.name, url: url, thumb: ch.streamIcon)));
  }

  void _playVod(VodItem v) {
    final url = XtreamService().getVodStreamUrl(v.streamId);
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => PlayerScreen(title: v.name, url: url, thumb: v.cover)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f0f0f),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        elevation: 0,
        title: Row(children: [
          Container(width: 30, height: 30,
            decoration: BoxDecoration(color: const Color(0xFFe03030), borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.tv, color: Colors.white, size: 16)),
          const SizedBox(width: 10),
          const Text('ARLUIS TV', style: TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 1, fontWeight: FontWeight.w500)),
        ]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1a1a1a),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF2a2a2a)),
              ),
              child: Text(widget.username, style: const TextStyle(color: Color(0xFFaaaaaa), fontSize: 13)),
            )),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF555555)),
            onPressed: _logout,
            tooltip: 'Cerrar sesión',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFe03030),
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xFF555555),
          tabs: const [
            Tab(icon: Icon(Icons.live_tv), text: 'En vivo'),
            Tab(icon: Icon(Icons.movie), text: 'Películas'),
            Tab(icon: Icon(Icons.tv), text: 'Series'),
          ],
        ),
      ),
      body: Column(children: [
        // Búsqueda
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Buscar...',
              hintStyle: const TextStyle(color: Color(0xFF444444)),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF555555)),
              filled: true,
              fillColor: const Color(0xFF1a1a1a),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF2a2a2a))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF2a2a2a))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFe03030))),
            ),
            onChanged: (v) => setState(() => _search = v.toLowerCase()),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildChannels(),
              _buildVodGrid(_vod, _loadingVod),
              _buildVodGrid(_series, _loadingSeries),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildChannels() {
    if (_loadingChannels) return const Center(child: CircularProgressIndicator(color: Color(0xFFe03030)));
    final list = _channels.where((c) => c.name.toLowerCase().contains(_search)).toList();
    if (list.isEmpty) return const Center(child: Text('Sin canales', style: TextStyle(color: Color(0xFF555555))));
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final ch = list[i];
        return GestureDetector(
          onTap: () => _playChannel(ch),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF161616),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF222222)),
            ),
            child: Row(children: [
              Container(width: 44, height: 44,
                decoration: BoxDecoration(color: const Color(0xFF1e1e1e), borderRadius: BorderRadius.circular(8)),
                child: ch.streamIcon.isNotEmpty
                  ? ClipRRect(borderRadius: BorderRadius.circular(8),
                      child: Image.network(ch.streamIcon, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.tv, color: Color(0xFF444444))))
                  : const Icon(Icons.tv, color: Color(0xFF444444)),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(ch.name, style: const TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(height: 4),
                Row(children: [
                  Container(width: 6, height: 6, decoration: BoxDecoration(
                    color: const Color(0xFFe03030), shape: BoxShape.circle)),
                  const SizedBox(width: 5),
                  const Text('EN VIVO', style: TextStyle(color: Color(0xFFe03030), fontSize: 10, letterSpacing: 1)),
                ]),
              ])),
              Text('${ch.num}', style: const TextStyle(color: Color(0xFF444444), fontSize: 12)),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildVodGrid(List<VodItem> items, bool loading) {
    if (loading) return const Center(child: CircularProgressIndicator(color: Color(0xFFe03030)));
    final list = items.where((v) => v.name.toLowerCase().contains(_search)).toList();
    if (list.isEmpty) return const Center(child: Text('Sin contenido', style: TextStyle(color: Color(0xFF555555))));
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, childAspectRatio: 0.65, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final v = list[i];
        return GestureDetector(
          onTap: () => _playVod(v),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF161616),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF222222)),
            ),
            child: Column(children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  child: v.cover.isNotEmpty
                    ? Image.network(v.cover, fit: BoxFit.cover, width: double.infinity,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.movie, color: Color(0xFF333333), size: 32)))
                    : const Center(child: Icon(Icons.movie, color: Color(0xFF333333), size: 32)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(v.name, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFFcccccc), fontSize: 11)),
              ),
            ]),
          ),
        );
      },
    );
  }
}
