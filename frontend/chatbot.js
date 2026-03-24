/* ============================================================
   YAMI  -  WanderWise AI Travel Assistant (Personalized v2)
   Context-aware, memory-driven, conversational chatbot.
   ============================================================ */

(function () {
  'use strict';

  // API base used for future live data fetching
  void 'http://localhost:8080/api';

  /* ── Conversation Memory ── */
  const memory = {
    name:       null,
    city:       null,
    budget:     null,
    tripType:   null,  // solo, couple, family, group
    duration:   null,
    mood:       null,  // adventure, relax, culture, beach, mountain
    msgCount:   0,
    askedName:  false,
    lastTopic:  null,
  };

  /* ── Knowledge Base ── */
  const DEST = {
    goa: {
      emoji: '🏖️',
      name: 'Goa',
      desc: 'Sun-soaked beaches, Portuguese churches, buzzing shacks and a nightlife scene that never sleeps.',
      vibe: 'beach vibes, nightlife, history, seafood',
      season: 'October to March',
      avoid: 'June–September (heavy monsoon)',
      budget: { low: 7500, mid: 15000, high: 45000 },
      days: '3–5 nights',
      bestFor: ['beach lovers', 'couples', 'solo backpackers', 'groups', 'party-goers'],
      hidden: 'Palolem in South Goa is far quieter and more beautiful than North Goa  -  perfect if you want peace over party.',
      food: 'Prawn curry rice, bebinca, fish thali, sorpotel, and the freshest calamari you\'ve ever had.',
      packages: ['Goa Sunshine Package', 'Goa Budget Backpacker', 'Goa Luxury Escape', 'Goa Couples Honeymoon', 'Goa Adventure Pack'],
    },
    manali: {
      emoji: '🏔️',
      name: 'Manali',
      desc: 'Snow-capped Himalayan peaks, river rafting, apple orchards, cosy cafés and that crisp mountain air.',
      vibe: 'mountains, snow, adventure, trekking, romance',
      season: 'March–June (trekking), December–February (snow)',
      avoid: 'July–August (landslides on roads)',
      budget: { low: 9500, mid: 16000, high: 24000 },
      days: '4–7 nights',
      bestFor: ['adventure seekers', 'couples', 'trekkers', 'ski lovers', 'solo travellers'],
      hidden: 'Old Manali village is completely different from the touristy Mall Road  -  tiny cafés, art studios, mellow vibes.',
      food: 'Siddu (stuffed bread with ghee), trout fish, Tibetan thukpa noodle soup, and hot apple pie from the bakeries.',
      packages: ['Manali Snow Escape', 'Manali Winter Wonderland', 'Manali Trekking Expedition', 'Manali Honeymoon Special'],
    },
    jaipur: {
      emoji: '🏰',
      name: 'Jaipur',
      desc: 'The Pink City  -  royal palaces, Hawa Mahal, Amber Fort, gem bazaars and Rajasthani hospitality.',
      vibe: 'heritage, culture, royalty, shopping, architecture',
      season: 'October to March',
      avoid: 'April–June (scorching 45°C heat)',
      budget: { low: 8000, mid: 18000, high: 55000 },
      days: '2–4 nights',
      bestFor: ['history lovers', 'photographers', 'families', 'culture seekers', 'luxury travellers'],
      hidden: 'Nahargarh Fort at sunset is jaw-dropping AND has way fewer tourists than Amber Fort. Don\'t miss it!',
      food: 'Dal baati churma, ghewar, laal maas, pyaaz kachori, and the most indulgent kulfi you\'ll ever eat.',
      packages: ['Jaipur Royal Tour', 'Jaipur Heritage Walk', 'Jaipur Royal Luxury', 'Golden Triangle Jaipur'],
    },
    kerala: {
      emoji: '🌴',
      name: 'Kerala',
      desc: 'God\'s Own Country  -  misty tea estates, houseboat backwaters, ancient Ayurveda, and the freshest seafood.',
      vibe: 'nature, wellness, backwaters, culture, beaches',
      season: 'September to March',
      avoid: 'June–August (monsoon, though Ayurveda season!)',
      budget: { low: 9500, mid: 20000, high: 35000 },
      days: '5–8 nights',
      bestFor: ['couples', 'wellness seekers', 'nature lovers', 'families', 'honeymoon'],
      hidden: 'Spend a night on a kettuvallam houseboat in the Alleppey backwaters  -  waking up to mist on the canals is pure magic.',
      food: 'Karimeen pollichathu (pearl spot fish), appam with stew, Kerala prawn curry, puttu and kadala.',
      packages: ['Kerala Serenity Trip', 'Kerala Backwater Dream', 'Kerala Ayurveda Retreat', 'Kerala Family Holiday'],
    },
    ladakh: {
      emoji: '🗻',
      name: 'Ladakh',
      desc: 'The roof of the world  -  Pangong Lake, Nubra Valley sand dunes, ancient monasteries and a sky full of stars.',
      vibe: 'adventure, photography, spirituality, raw nature',
      season: 'June to September ONLY',
      avoid: 'October–May (roads closed, extreme cold)',
      budget: { low: 14000, mid: 25000, high: 42000 },
      days: '6–10 nights',
      bestFor: ['adventure seekers', 'photographers', 'bikers', 'solo travellers', 'spiritual seekers'],
      hidden: 'Tso Moriri lake is even more stunning than Pangong Tso and almost tourist-free. Worth the extra drive!',
      food: 'Thukpa, momos, butter tea (an acquired taste!), tsampa barley porridge, and yak cheese.',
      packages: ['Ladakh Adventure', 'Ladakh Luxury Camp', 'Ladakh Bike Expedition', 'Ladakh Solo Backpacker'],
    },
    udaipur: {
      emoji: '🏯',
      name: 'Udaipur',
      desc: 'The City of Lakes  -  white marble palaces floating on Lake Pichola, royal heritage, and the most romantic sunsets in Rajasthan.',
      vibe: 'romance, heritage, lakes, royal culture, luxury',
      season: 'October to March',
      avoid: 'April–June (very hot)',
      budget: { low: 8000, mid: 18000, high: 50000 },
      days: '2–4 nights',
      bestFor: ['honeymoon couples', 'photographers', 'history lovers', 'luxury travellers', 'romantics'],
      hidden: 'Dine at a rooftop restaurant facing the illuminated City Palace at night  -  it\'s genuinely magical and not overcrowded.',
      food: 'Dal baati churma, gatte ki sabzi, ker sangri, mawa kachori, and lassi in the old city lanes.',
      packages: ['Udaipur Lake Palace Tour', 'Udaipur Romantic Getaway', 'Udaipur Heritage Walk', 'Udaipur Luxury Experience'],
    },
    rishikesh: {
      emoji: '🌊',
      name: 'Rishikesh',
      desc: 'Where the Ganges thunders down from the Himalayas  -  yoga capital, white-water rafting, bungee jumping, and ashram serenity.',
      vibe: 'adventure, spiritual, yoga, nature, Ganges',
      season: 'February to June, September to November',
      avoid: 'July–August (peak monsoon, no rafting)',
      budget: { low: 6000, mid: 12000, high: 22000 },
      days: '3–5 nights',
      bestFor: ['adventure seekers', 'solo travellers', 'spiritual seekers', 'yoga enthusiasts', 'backpackers'],
      hidden: 'Attend the Ganga Aarti at Triveni Ghat (not just Parmarth Niketan)  -  it\'s smaller, more intimate, and deeply moving.',
      food: 'Maggi at roadside dhabas (the iconic Rishikesh experience!), rajma rice, banana lassi, and fresh fruit bowls at cafes on the ghats.',
      packages: ['Rishikesh Adventure Escape', 'Rishikesh Yoga Retreat', 'Rishikesh Spiritual Tour', 'Rishikesh Backpacker Budget'],
    },
    darjeeling: {
      emoji: '🍵',
      name: 'Darjeeling',
      desc: 'The Queen of Hills  -  emerald tea gardens, the UNESCO toy train, and Kanchenjunga rising from the clouds at dawn.',
      vibe: 'tea, Himalayas, colonial charm, nature, sunrise',
      season: 'March to May, October to November',
      avoid: 'June–September (heavy monsoon, foggy)',
      budget: { low: 7500, mid: 14000, high: 25000 },
      days: '3–4 nights',
      bestFor: ['nature lovers', 'tea enthusiasts', 'couples', 'photographers', 'history buffs'],
      hidden: 'Hire a local guide to visit a working tea garden for free  -  most estates let you pick tea during the season and even keep a small bunch.',
      food: 'Darjeeling First Flush tea (the champagne of teas!), momos, thukpa, aloo dum, and fresh-baked croissants at Glenary\'s bakery.',
      packages: ['Darjeeling Tea & Sunrise Tour', 'Darjeeling Himalayan Trek', 'Darjeeling Heritage Tour', 'Darjeeling Family Escape'],
    },
    shimla: {
      emoji: '❄️',
      name: 'Shimla',
      desc: 'The old Summer Capital of British India  -  Victorian buildings, the famous Mall Road, pine forests, and Himalayan snowscapes.',
      vibe: 'colonial, snow, mountains, peaceful, scenic',
      season: 'March to June, December to January',
      avoid: 'July–September (heavy rain, landslides)',
      budget: { low: 7000, mid: 13000, high: 22000 },
      days: '3–4 nights',
      bestFor: ['families', 'couples', 'history lovers', 'snow seekers', 'weekend trippers'],
      hidden: 'Walk down to Jakhu Temple before tourists arrive at dawn  -  monkeys, misty forest paths, and a giant Hanuman statue above the clouds.',
      food: 'Sidu (Himachali stuffed bread with ghee), kadhi chawal, tudkiya bhath (Shimla rice), fresh apple juice, and Tibetan momos.',
      packages: ['Shimla Snow Retreat', 'Shimla Heritage Tour', 'Shimla Family Holiday', 'Shimla–Manali Combo'],
    },
    varanasi: {
      emoji: '🕯️',
      name: 'Varanasi',
      desc: 'One of the world\'s oldest cities  -  88 ghats on the sacred Ganga, the hypnotic Aarti, silk weavers, and 3,000 years of continuous history.',
      vibe: 'spiritual, culture, ancient, ghats, Ganga',
      season: 'October to March',
      avoid: 'May–June (extreme heat 45°C+)',
      budget: { low: 6000, mid: 12000, high: 20000 },
      days: '2–3 nights',
      bestFor: ['spiritual seekers', 'photographers', 'culture lovers', 'history buffs', 'solo travellers'],
      hidden: 'Take a boat at 5 AM  -  before any tour group  -  and watch the city wake up to dawn prayers. It\'s the most haunting, beautiful thing you\'ll see in India.',
      food: 'Kachori sabzi for breakfast, chaat at Deena Chat Bhandar, Banarasi paan, thandai, malaiyo (winter morning sweet), and the famous lassi at Blue Lassi Shop.',
      packages: ['Varanasi Spiritual Tour', 'Varanasi Heritage Walk', 'Varanasi Ganga Cruise', 'Varanasi Cultural Immersion'],
    },
    agra: {
      emoji: '🕌',
      name: 'Agra',
      desc: 'Home of the Taj Mahal  -  the world\'s greatest monument to love, plus Agra Fort, Fatehpur Sikri, and Mughal history at every corner.',
      vibe: 'heritage, Mughal, iconic landmarks, history',
      season: 'October to March',
      avoid: 'May–July (extreme heat, Taj haze)',
      budget: { low: 5000, mid: 10000, high: 20000 },
      days: '1–2 nights',
      bestFor: ['history lovers', 'first-time India visitors', 'photographers', 'couples', 'families'],
      hidden: 'Book a sunrise slot at the Taj  -  the dawn light turns the marble pale pink and the crowds haven\'t arrived yet. Worth every effort.',
      food: 'Petha sweet (Agra\'s iconic translucent candy in dozens of flavours), bedai kachori, jalebi from Deviram\'s, and dal moth.',
      packages: ['Agra Taj Mahal Day Tour', 'Agra Heritage Tour', 'Golden Triangle (Delhi–Agra–Jaipur)', 'Agra Overnight Package'],
    },
    coorg: {
      emoji: '☕',
      name: 'Coorg',
      desc: 'The Scotland of India  -  misty coffee and cardamom estates, roaring waterfalls, tribal culture, and jungle safaris in Karnataka\'s most beautiful district.',
      vibe: 'nature, coffee, forest, waterfalls, peaceful',
      season: 'October to May',
      avoid: 'June–September (heavy monsoon)',
      budget: { low: 7500, mid: 15000, high: 28000 },
      days: '3–4 nights',
      bestFor: ['nature lovers', 'couples', 'families', 'coffee enthusiasts', 'trekkers'],
      hidden: 'Stay in a homestay run by a Kodava family  -  they\'ll cook you pandi curry (pork) and share stories of their warrior heritage. Completely different from a resort.',
      food: 'Pandi curry (Coorg pork curry), kadambuttu (rice dumplings), nool puttu, akki rotti, and freshly brewed estate coffee at sunrise.',
      packages: ['Coorg Coffee Estate Retreat', 'Coorg Nature Explorer', 'Coorg Wildlife Safari', 'Coorg Romantic Escape'],
    },
    ooty: {
      emoji: '🌸',
      name: 'Ooty',
      desc: 'The Queen of Hill Stations  -  Nilgiri tea estates, the UNESCO toy train, botanical gardens, and crisp mountain air in Tamil Nadu\'s famous resort town.',
      vibe: 'hills, tea, nature, colonial, peaceful',
      season: 'April to June, September to November',
      avoid: 'December–January (very cold at night); June–August (monsoon)',
      budget: { low: 6000, mid: 12000, high: 20000 },
      days: '2–3 nights',
      bestFor: ['families', 'couples', 'nature lovers', 'solo travellers', 'honeymoon'],
      hidden: 'Visit Pykara Lake and Falls  -  far fewer tourists than Ooty town and an absolutely serene landscape of shola forest and grassland.',
      food: 'Nilgiri tea (world-famous), fresh homemade Ooty chocolates, varkey (crispy pastry), upma, and filter coffee at any small hotel.',
      packages: ['Ooty Nilgiri Escape', 'Ooty Family Tour', 'Ooty–Coorg Combo', 'Ooty Honeymoon Special'],
    },
    mysore: {
      emoji: '🏛️',
      name: 'Mysore',
      desc: 'The City of Palaces  -  the magnificent illuminated Mysore Palace, Dasara processions, sandalwood bazaars, and South India\'s most regal city.',
      vibe: 'heritage, culture, palaces, festival, royalty',
      season: 'October to March',
      avoid: 'April–May (hot)',
      budget: { low: 6000, mid: 12000, high: 22000 },
      days: '2–3 nights',
      bestFor: ['history lovers', 'culture seekers', 'families', 'photographers', 'weekend trippers'],
      hidden: 'Visit the Mysore Palace on a Sunday evening  -  it\'s illuminated with 96,000 light bulbs for one hour and the sight is absolutely jaw-dropping.',
      food: 'Mysore pak (the original!  -  rich ghee-based sweet), Mysore masala dosa, chitranna (lemon rice), bisi bele bath, and fresh jasmine garlands from the flower market.',
      packages: ['Mysore Palace Tour', 'Mysore–Coorg Combo', 'Mysore Cultural Heritage', 'Mysore Dasara Festival Tour'],
    },
    hampi: {
      emoji: '🏛️',
      name: 'Hampi',
      desc: 'The Lost Empire  -  UNESCO ruins of the mighty Vijayanagara Kingdom scattered across an otherworldly landscape of boulders, banana groves, and the Tungabhadra river.',
      vibe: 'ancient ruins, history, photography, surreal landscape, backpacker',
      season: 'October to February',
      avoid: 'March–May (extreme heat 40°C+)',
      budget: { low: 5000, mid: 10000, high: 18000 },
      days: '2–3 nights',
      bestFor: ['history lovers', 'photographers', 'backpackers', 'solo travellers', 'architecture buffs'],
      hidden: 'Rent a bicycle and cross the river to the "hippie island" side (Virupapur Gaddi)  -  laid-back guesthouses, paddy fields, and temples without the main-side crowds.',
      food: 'Hampi has surprisingly great cafes  -  try the banana pancakes, honey lassi, and fresh coconut water. Local thali with jolada roti and kadlekai usli.',
      packages: ['Hampi Heritage Explorer', 'Hampi Ruins & Culture Tour', 'Hampi Backpacker Special', 'Hampi–Badami Combo'],
    },
  };

  const TRIP_TYPES = {
    solo:     { label:'solo traveller', emoji:'🎒', cities:['goa','rishikesh','ladakh','hampi','varanasi','manali'] },
    couple:   { label:'couple', emoji:'💕', cities:['udaipur','kerala','goa','shimla','coorg','manali'] },
    family:   { label:'family', emoji:'👨‍👩‍👧‍👦', cities:['jaipur','kerala','ooty','mysore','shimla','agra'] },
    friends:  { label:'friends group', emoji:'🎉', cities:['goa','manali','ladakh','rishikesh'] },
    honeymoon:{ label:'honeymoon couple', emoji:'💍', cities:['udaipur','kerala','coorg','goa','darjeeling'] },
  };

  /* ── Time-based greeting ── */
  function timeGreeting() {
    const h = new Date().getHours();
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  /* ── Extract city from message ── */
  function detectCity(msg) {
    if (msg.includes('goa'))                                                                              return 'goa';
    if (msg.includes('manali') || msg.includes('rohtang') || msg.includes('solang'))                     return 'manali';
    if (msg.includes('jaipur') || msg.includes('pink city') || msg.includes('hawa mahal') || msg.includes('amber fort')) return 'jaipur';
    if (msg.includes('kerala') || msg.includes('alleppey') || msg.includes('munnar') || msg.includes('kochi')) return 'kerala';
    if (msg.includes('ladakh') || msg.includes('leh') || msg.includes('pangong') || msg.includes('nubra')) return 'ladakh';
    if (msg.includes('udaipur') || msg.includes('lake pichola') || msg.includes('city of lakes'))        return 'udaipur';
    if (msg.includes('rishikesh') || msg.includes('haridwar') || msg.includes('shivpuri') || msg.includes('ganga aarti')) return 'rishikesh';
    if (msg.includes('darjeeling') || msg.includes('toy train') || msg.includes('tiger hill') || msg.includes('kanchenjunga')) return 'darjeeling';
    if (msg.includes('shimla') || msg.includes('kufri') || msg.includes('mall road'))                    return 'shimla';
    if (msg.includes('varanasi') || msg.includes('banaras') || msg.includes('benares') || msg.includes('kashi') || msg.includes('ganga ghat')) return 'varanasi';
    if (msg.includes('agra') || msg.includes('taj mahal') || msg.includes('fatehpur sikri'))             return 'agra';
    if (msg.includes('coorg') || msg.includes('kodagu') || msg.includes('coffee estate') || msg.includes('kodava')) return 'coorg';
    if (msg.includes('ooty') || msg.includes('udhagamandalam') || msg.includes('nilgiri') || msg.includes('doddabetta')) return 'ooty';
    if (msg.includes('mysore') || msg.includes('mysuru') || msg.includes('mysore palace') || msg.includes('dasara')) return 'mysore';
    if (msg.includes('hampi') || msg.includes('vijayanagara') || msg.includes('vittala') || msg.includes('tungabhadra')) return 'hampi';
    return null;
  }

  /* ── Extract budget from message ── */
  function detectBudget(msg) {
    const num = msg.match(/₹?\s*(\d[\d,]*)/)?.[1]?.replace(/,/g,'');
    return num ? parseInt(num) : null;
  }

  /* ── Extract trip type ── */
  function detectTripType(msg) {
    if (msg.includes('honeymoon') || msg.includes('newly wed'))    return 'honeymoon';
    if (msg.includes('family') || msg.includes('kids') || msg.includes('parents') || msg.includes('children')) return 'family';
    if (msg.includes('solo') || msg.includes('alone') || msg.includes('myself') || msg.includes('by myself')) return 'solo';
    if (msg.includes('friends') || msg.includes('gang') || msg.includes('group') || msg.includes('squad')) return 'friends';
    if (msg.includes('couple') || msg.includes('partner') || msg.includes('girlfriend') || msg.includes('boyfriend') || msg.includes('wife') || msg.includes('husband') || msg.includes('romantic')) return 'couple';
    return null;
  }

  /* ── Extract mood/style ── */
  function detectMood(msg) {
    if (msg.includes('adventure') || msg.includes('trek') || msg.includes('thrilling') || msg.includes('exciting') || msg.includes('bungee') || msg.includes('rafting')) return 'adventure';
    if (msg.includes('relax') || msg.includes('chill') || msg.includes('peaceful') || msg.includes('calm') || msg.includes('ayurveda') || msg.includes('spa') || msg.includes('yoga') || msg.includes('wellness')) return 'relax';
    if (msg.includes('culture') || msg.includes('heritage') || msg.includes('history') || msg.includes('fort') || msg.includes('temple') || msg.includes('museum')) return 'culture';
    if (msg.includes('beach') || msg.includes('sea') || msg.includes('ocean') || msg.includes('swim') || msg.includes('surf')) return 'beach';
    if (msg.includes('mountain') || msg.includes('snow') || msg.includes('hill') || msg.includes('peak')) return 'mountain';
    return null;
  }

  /* ── Personalized name usage ── */
  function namePrefix() {
    return memory.name ? `${memory.name}, ` : '';
  }

  /* ── Package suggestion by budget ── */
  function pkgByBudget(budget, city) {
    const d = city ? DEST[city] : null;
    const low = budget < 12000;
    const mid = budget >= 12000 && budget <= 25000;

    if (city && d) {
      if (low) return `For **${d.name}** under ₹${budget.toLocaleString('en-IN')}, the **${d.packages[0]}** is your best bet  -  great value with all the highlights included! 🎯`;
      if (mid) return `For **${d.name}** around ₹${budget.toLocaleString('en-IN')}, I'd suggest the **${d.packages[1] || d.packages[0]}**  -  it covers the best experiences without breaking the bank! 🎯`;
      return `With ₹${budget.toLocaleString('en-IN')} for **${d.name}**, you can go for the **${d.packages[d.packages.length-1]}**  -  a premium experience with amazing inclusions! 🌟`;
    }

    if (low)  return `On a budget of ₹${budget.toLocaleString('en-IN')}, I'd suggest:\n\n🏖️ **Goa Budget Backpacker**  -  ₹7,500 (3 nights)\n🏔️ **Manali Budget Escape**  -  ₹9,500 (3 nights)\n🏰 **Jaipur Budget Traveller**  -  ₹8,000 (2 nights)\n\nAll include a great stay + experiences!`;
    if (mid)  return `For ₹${budget.toLocaleString('en-IN')}, some amazing picks:\n\n🏖️ **Goa Sunshine Package**  -  ₹15,000 (4 nights)\n🏔️ **Manali Snow Escape**  -  ₹12,000 (5 nights)\n🏰 **Jaipur Royal Tour**  -  ₹18,000 (3 nights)\n🌴 **Kerala Serenity Trip**  -  ₹20,000 (6 nights)`;
    return `With ₹${budget.toLocaleString('en-IN')}, the premium experiences open up:\n\n🌴 **Kerala Ayurveda Retreat**  -  ₹35,000 (7 nights)\n🏖️ **Goa Luxury Escape**  -  ₹45,000 (5 nights)\n🏰 **Jaipur Royal Luxury**  -  ₹55,000 (4 nights)\n🗻 **Ladakh Luxury Camp**  -  ₹42,000 (7 nights)`;
  }

  /* ── Smart response engine ── */
  function respond(input) {
    const msg  = input.toLowerCase().trim();
    memory.msgCount++;

    // Update memory from this message
    const detectedCity    = detectCity(msg);
    const detectedBudget  = detectBudget(msg);
    const detectedType    = detectTripType(msg);
    const detectedMood    = detectMood(msg);
    if (detectedCity)   memory.city     = detectedCity;
    if (detectedBudget) memory.budget   = detectedBudget;
    if (detectedType)   memory.tripType = detectedType;
    if (detectedMood)   memory.mood     = detectedMood;

    // Extract name ("I'm Ashmika" / "my name is ..." / "call me ...")
    const nameMatch = msg.match(/(?:i'?m|my name is|call me|i am)\s+([a-z]+)/i);
    if (nameMatch && !memory.name) {
      const candidate = nameMatch[1];
      if (!['a','going','planning','looking','thinking','trying'].includes(candidate.toLowerCase())) {
        memory.name = candidate.charAt(0).toUpperCase() + candidate.slice(1);
        return `${memory.name}! What a lovely name 😊 It's so nice to meet you! I'm Yami  -  your personal travel guide here at WanderWise.\n\nSo ${memory.name}, where are you dreaming of going? Goa, Manali, Jaipur, Kerala, or Ladakh? Or tell me your travel style and I'll suggest the perfect destination! 🌏`;
      }
    }

    // Greeting
    const greetWords = ['hi','hello','hey','namaste','hii','heyy','howdy','yo','sup','heya'];
    if (greetWords.some(g => msg === g || msg.startsWith(g+' ') || msg.startsWith(g+'!'))) {
      if (!memory.askedName) {
        memory.askedName = true;
        return `${timeGreeting()}! 🌊 I'm **Yami**, your WanderWise travel buddy!\n\nBefore we dive in  -  what's your name? I'd love to make this feel personal! 😊`;
      }
      return `Hey${memory.name ? ' ' + memory.name : ''}! 👋 Great to see you again! What travel plans are we cooking up today? ✈️`;
    }

    // Thanks
    if (['thanks','thank you','thankyou','thx','ty'].some(t => msg.includes(t))) {
      return `Absolutely${memory.name ? ', ' + memory.name : ''}! 😊 That's what I'm here for. Is there anything else you'd like to explore? I'm all yours! 🌟`;
    }

    // Bye
    if (['bye','goodbye','see you','take care','cya','later','gotta go'].some(b => msg.includes(b))) {
      return `Bye${memory.name ? ' ' + memory.name : ''}! 👋 Safe travels and amazing adventures ahead! Come back whenever you need me. WanderWise loves you! 💙`;
    }

    // About Yami
    if (msg.includes('who are you') || msg.includes('what are you') || msg.includes('your name') || msg.includes('yami')) {
      return `I'm **Yami** 🌊  -  WanderWise's AI travel assistant!\n\nI was built to help you discover the magic of India  -  from Goa's beaches to Ladakh's monasteries.\n\nI'm not just a bot though. I remember what you tell me, learn your travel style, and give you personalised recommendations${memory.name ? ', ' + memory.name : ''}! 💙\n\nSo  -  where are we going? 🗺️`;
    }

    // Destination specific  -  with personalised context
    if (detectedCity) {
      return destResponse(detectedCity, msg);
    }

    // Budget query  -  context aware
    if (detectedBudget || msg.includes('budget') || msg.includes('cheap') || msg.includes('affordable') || msg.includes('cost') || msg.includes('price') || msg.includes('how much') || msg.includes('under')) {
      const budget = detectedBudget || memory.budget;
      if (budget) {
        const reply = pkgByBudget(budget, memory.city);
        const followUp = memory.city
          ? `\n\nWant me to show you hotels or transport options for ${DEST[memory.city].name} too? 😊`
          : `\n\nDo you have a destination in mind? Tell me and I'll get even more specific! 🎯`;
        return reply + followUp;
      }
      return `${namePrefix()}To find the best package for you, what's your rough budget per person? 💰\n\nFor example:\n• Under ₹10,000  -  great budget options\n• ₹10,000–₹25,000  -  mid-range, most popular\n• ₹25,000+  -  premium & luxury experiences`;
    }

    // Trip type  -  personalized
    if (detectedType) {
      return tripTypeResponse(detectedType);
    }

    // Mood/style
    if (detectedMood) {
      return moodResponse(detectedMood);
    }

    // "Where should I go" / recommendations
    if (msg.includes('where should') || msg.includes('recommend') || msg.includes('suggest') || msg.includes('which destination') || msg.includes('best place') || msg.includes('where to go') || (msg.includes('where') && msg.includes('go'))) {
      return smartRecommend();
    }

    // All destinations list
    if (msg.includes('destination') || msg.includes('all places') || msg.includes('options')) {
      return `${namePrefix()}we cover **15 stunning destinations** across India! Here's a quick overview:\n\n🏖️ **Goa**  -  beaches, nightlife, Portuguese vibes\n🏔️ **Manali**  -  snow, adventure, Himalayan magic\n🏰 **Jaipur**  -  royal heritage, forts, bazaars\n🌴 **Kerala**  -  backwaters, Ayurveda, tea estates\n🗻 **Ladakh**  -  high-altitude lakes, monasteries, stars\n🏯 **Udaipur**  -  lake palaces, romance, sunsets\n🌊 **Rishikesh**  -  yoga capital, rafting, Ganga Aarti\n🍵 **Darjeeling**  -  tea gardens, toy train, Himalayan sunrise\n❄️ **Shimla**  -  colonial hill town, pine forests, snow\n🕯️ **Varanasi**  -  world's oldest city, sacred ghats\n🕌 **Agra**  -  Taj Mahal, Mughal grandeur\n☕ **Coorg**  -  coffee estates, waterfalls, jungle\n🌸 **Ooty**  -  Nilgiri hills, botanical gardens\n🏛️ **Mysore**  -  palace city, Dasara festival\n🗿 **Hampi**  -  UNESCO ancient ruins, surreal landscape\n\nWhich one catches your eye? Or tell me your travel style and I'll pick the perfect one! 😊`;
    }

    // Package query
    if (msg.includes('package') || msg.includes('deal') || msg.includes('offer') || msg.includes('combo')) {
      if (memory.city && memory.budget) {
        return pkgByBudget(memory.budget, memory.city) + `\n\nYou can book this directly from the **Plan a Trip** page! Want me to tell you what's included? 📦`;
      }
      if (memory.city) {
        const d = DEST[memory.city];
        return `For **${d.name}** ${d.emoji}, here are the packages I'd recommend:\n\n${d.packages.map((p,i) => `${i===0?'⭐':i===1?'🔥':'📦'} **${p}**`).join('\n')}\n\nWhat's your budget? I can narrow it down to the perfect one for you!`;
      }
      return `${namePrefix()}we have **35+ packages** across all 5 destinations! To find your perfect match, tell me:\n\n1️⃣ Where do you want to go?\n2️⃣ What's your budget per person?\n3️⃣ How many nights?\n\nI'll do the rest! 😊`;
    }

    // Hotel query
    if (msg.includes('hotel') || msg.includes('stay') || msg.includes('accommodation') || msg.includes('hostel') || msg.includes('resort') || msg.includes('where to stay')) {
      if (memory.city) return hotelResp(memory.city, memory.budget);
      return `${namePrefix()}which city are you looking for a stay in? 🏨\n\nWe have everything from ₹799/night hostels to ₹18,000/night palace hotels across Goa, Manali, Jaipur, Kerala and Ladakh!`;
    }

    // Transport query
    if (msg.includes('flight') || msg.includes('train') || msg.includes('bus') || msg.includes('transport') || msg.includes('how to reach') || msg.includes('how to go') || msg.includes('reach') || msg.includes('travel to') || msg.includes('get to')) {
      if (memory.city) return transportResp(memory.city);
      return `${namePrefix()}which destination are you trying to reach? Tell me the city and your starting point (like *"Delhi to Goa"*) and I'll give you all the flight, train and bus options! 🚀`;
    }

    // Season / weather
    if (msg.includes('best time') || msg.includes('when to visit') || msg.includes('when should') || msg.includes('season') || msg.includes('weather') || msg.includes('climate')) {
      if (memory.city) {
        const d = DEST[memory.city];
        return `**Best time to visit ${d.name} ${d.emoji}:**\n\n✅ **Go during:** ${d.season}\n❌ **Avoid:** ${d.avoid}\n\n${seasonTip(memory.city)}`;
      }
      return `Great question${memory.name ? ', ' + memory.name : ''}! Here's a quick seasonal guide:\n\n🏖️ **Goa**  -  Oct to Mar (perfect beach weather)\n🏔️ **Manali**  -  Mar–Jun for trekking, Dec–Feb for snow\n🏰 **Jaipur**  -  Oct to Mar (cool & pleasant)\n🌴 **Kerala**  -  Sep to Mar (lush post-monsoon)\n🗻 **Ladakh**  -  Jun to Sep ONLY (roads close in winter!)\n\nWhich destination are you planning for?`;
    }

    // Food query
    if (msg.includes('food') || msg.includes('eat') || msg.includes('cuisine') || msg.includes('restaurant') || msg.includes('dish') || msg.includes('local food')) {
      if (memory.city) {
        const d = DEST[memory.city];
        return `Oh, the food in **${d.name}** is incredible ${d.emoji}!\n\n🍽️ ${d.food}\n\nSeriously${memory.name ? ', ' + memory.name : ''}, the local food alone is worth the trip. Don't eat at any tourist restaurant  -  always go where the locals eat! 😋`;
      }
      return `Indian food is an adventure in itself! Tell me which destination and I'll spill all the must-try dishes 🍛\n\nEach city has its own iconic cuisine  -  Goa's seafood, Jaipur's dal baati, Kerala's appam, Manali's thukpa, Ladakh's momos!`;
    }

    // Hidden gems
    if (msg.includes('hidden') || msg.includes('secret') || msg.includes('offbeat') || msg.includes('less crowd') || msg.includes('underrated') || msg.includes('local tip') || msg.includes('insider')) {
      if (memory.city) {
        const d = DEST[memory.city];
        return `Ooh, love that you asked this${memory.name ? ', ' + memory.name : ''}! 🤫 Here's my insider tip for **${d.name}**:\n\n✨ ${d.hidden}\n\nMost tourists miss this completely. You'll thank me later! 😉`;
      }
      return `I love sharing local secrets! 🤫 Ask me about a specific destination and I'll give you my best insider tip for it. Which one?`;
    }

    // Booking help
    if (msg.includes('book') || msg.includes('how to book') || msg.includes('reserve') || msg.includes('confirm')) {
      return `Booking is super easy${memory.name ? ', ' + memory.name : ''}! Here's how:\n\n1️⃣ Click **Plan a Trip** in the nav bar\n2️⃣ Pick **${memory.city ? DEST[memory.city].name : 'your destination'}**\n3️⃣ Choose your dates\n4️⃣ Select a hotel\n5️⃣ Add transport (optional)\n6️⃣ Hit **Confirm Booking**  -  done! 🎉\n\nNeed help deciding which hotel or package to pick?`;
    }

    // Follow-up on previous context
    if (memory.msgCount > 3 && memory.city && (msg.includes('yes') || msg.includes('yeah') || msg.includes('sure') || msg.includes('okay') || msg.includes('ok') || msg.includes('tell me more'))) {
      return followUp();
    }

    // "Tell me more" or "more details"
    if (msg.includes('more') || msg.includes('details') || msg.includes('tell me') || msg.includes('elaborate') || msg.includes('explain')) {
      if (memory.city) return destDeep(memory.city);
      return `I'd love to tell you more! More about what? A specific destination, a package, hotels, or transport? Just say the word 😊`;
    }

    // Confused / no match  -  context-aware fallback
    return smartFallback(msg);
  }

  /* ── Destination response (personalised) ── */
  function destResponse(city, _msg) {
    const d = DEST[city];
    const tt = memory.tripType;
    const isGoodFit = tt ? TRIP_TYPES[tt]?.cities.includes(city) : true;

    let opening = ``;
    if (memory.name) opening = `Great choice, ${memory.name}! `;
    if (tt === 'honeymoon' && ['kerala','goa','manali'].includes(city)) opening += `**${d.name}** is honestly one of the most romantic destinations in India 💕\n\n`;
    else if (tt === 'family' && ['jaipur','kerala','goa'].includes(city)) opening += `**${d.name}** is brilliant for families  -  there's something for every age! 👨‍👩‍👧‍👦\n\n`;
    else if (tt === 'solo' && ['goa','manali','ladakh'].includes(city)) opening += `**${d.name}** is amazing for solo travel  -  very safe, lots of fellow backpackers to meet! 🎒\n\n`;
    else opening += `**${d.name}** ${d.emoji} is a fantastic choice!\n\n`;

    let body = `${d.desc}\n\n`;
    body += `🌟 **Vibe:** ${d.vibe}\n`;
    body += `📅 **Best time:** ${d.season}\n`;
    body += `💰 **Budget range:** ₹${d.budget.low.toLocaleString('en-IN')} – ₹${d.budget.high.toLocaleString('en-IN')} per person\n`;
    body += `🛏️ **Ideal stay:** ${d.days}`;

    let followup = `\n\nWhat would you like to know next?\n• 🏨 Hotels in ${d.name}\n• 📦 Packages for ${d.name}\n• 🚀 How to reach ${d.name}\n• 🍽️ Food & local tips`;

    if (!isGoodFit && tt) {
      followup += `\n\n💡 *Psst  -  for a ${TRIP_TYPES[tt].label}, ${DEST[TRIP_TYPES[tt].cities[0]].name} might actually be an even better fit. Want me to compare?*`;
    }

    return opening + body + followup;
  }

  /* ── Deeper destination info ── */
  function destDeep(city) {
    const d = DEST[city];
    return `Here's everything about **${d.name}** ${d.emoji}:\n\n🤫 **Hidden gem:** ${d.hidden}\n\n🍽️ **Must-eat:** ${d.food}\n\n📦 **Top packages:**\n${d.packages.slice(0,3).map(p => `• ${p}`).join('\n')}\n\n❌ **Avoid visiting during:** ${d.avoid}\n\n${memory.name ? 'Trust me, ' + memory.name + ', ' : ''}you\'re going to love it! 🌟`;
  }

  /* ── Trip type personalised response ── */
  function tripTypeResponse(type) {
    const name = memory.name ? `${memory.name}` : null;

    const responses = {
      honeymoon: `A honeymoon  -  how exciting${name ? ', ' + name : ''}! Congratulations! 🥂💍\n\nFor a dreamy romantic escape, here's what I'd suggest:\n\n🌴 **Kerala**  -  houseboat nights on misty backwaters, Ayurveda couples spa, absolute magic\n🏖️ **Goa**  -  boutique beach resort, sunset cruises, candlelit seafood dinners\n🏔️ **Manali**  -  mountain cottage, snow walks, couples spa and warm bonfires\n\nDo you prefer beaches 🏖️, mountains 🏔️, or nature & wellness 🌿?`,
      family: `A family trip  -  love it${name ? ', ' + name : ''}! 👨‍👩‍👧‍👦\n\nHere are my top family-friendly destinations:\n\n🏰 **Jaipur**  -  forts, camel rides, Chokhi Dhani cultural village  -  kids absolutely love it!\n🌴 **Kerala**  -  houseboat, wildlife safari, Munnar  -  something for every generation\n🏖️ **Goa**  -  calm South Goa beaches, water sports, and amazing fresh seafood\n\nHow old are the kids? That helps me suggest the most fun activities! 😊`,
      solo: `Solo travel is the BEST kind${name ? ', ' + name : ''}! 🎒 You're going to have an incredible time.\n\nTop solo-friendly destinations:\n\n🏖️ **Goa**  -  huge backpacker community, super safe, Zostel has amazing social vibes\n🏔️ **Manali**  -  meet fellow trekkers, amazing hostel cafes in Old Manali\n🗻 **Ladakh**  -  solo bikers and trekkers everywhere, incredible scenery\n🌴 **Kerala**  -  safe, beautiful, great solo hostels in Fort Kochi\n\nWhat's your travel mood  -  adventure 🧗, chill 🌅, or culture 🏛️?`,
      friends: `A friends trip?! The best kind${name ? ', ' + name : ''}! 🎉\n\nFor an epic squad trip:\n\n🏖️ **Goa**  -  beach parties, water sports, nightlife, group villa stays  -  the classic!\n🏔️ **Manali**  -  adventure, skiing, river rafting, bonfire nights  -  absolute blast\n🗻 **Ladakh**  -  Bike expedition on Royal Enfields  -  bucket list material!\n\nHow big is the group? And are you all about parties 🎊 or adventures 🧗?`,
      couple: `How romantic${name ? ', ' + name : ''}! 💕 Here are my top picks for couples:\n\n🌴 **Kerala**  -  the most intimate destination in India, misty backwaters, Ayurveda\n🏖️ **Goa**  -  beach sunsets, great food, boutique resorts, warm evenings\n🏔️ **Manali**  -  snow walks, cosy mountain cafes, bonfire dinners\n🏰 **Jaipur**  -  feel like royalty together in a heritage palace hotel!\n\nWhat kind of vibe are you two after? 😊`,
    };
    return responses[type] || `Tell me more about your trip and I'll suggest the perfect destination! 😊`;
  }

  /* ── Mood-based response ── */
  function moodResponse(mood) {
    const name = memory.name;
    const addr = name ? `${name}, ` : '';
    const moods = {
      adventure: `${addr}sounds like you're a thrill-seeker! 🧗‍♂️ Let's find your adventure:\n\n🏔️ **Manali**  -  Beas river rafting, Rohtang Pass, Solang skiing, Bhrigu Lake trek\n🗻 **Ladakh**  -  Zanskar Valley trek, Khardung La (world's highest motorable road!), Nubra dunes\n🏖️ **Goa**  -  scuba diving, parasailing, jet skiing, water sports at Calangute\n\nWhich gets your heart racing most?`,
      relax: `${addr}you need a proper escape from the chaos! 🧘‍♀️ Perfect choices:\n\n🌴 **Kerala**  -  Ayurveda Panchakarma retreats, houseboat drifting, yoga at sunrise\n🏔️ **Manali**  -  mountain silence, apple orchards, no-schedule walks by the Beas river\n🗻 **Ladakh**  -  star-gazing at Tso Moriri with zero light pollution, monastic peace\n\nHow long can you unplug for?`,
      culture: `${addr}a history and culture lover  -  my favourite kind of traveller! 🏛️\n\n🏰 **Jaipur**  -  Amber Fort, Hawa Mahal, City Palace, Jantar Mantar  -  UNESCO heritage all around\n🌴 **Kerala**  -  Kathakali performances, Fort Kochi spice trade history, Jewish Synagogue\n🗻 **Ladakh**  -  500-year-old Thiksey & Hemis monasteries, Tibetan Buddhist culture\n\nAny of these calling to you?`,
      beach: `${addr}the ocean is calling! 🌊\n\n🏖️ **Goa** is the obvious star  -  30+ beaches, each with its own personality:\n• **Palolem**  -  quiet, crescent-shaped, stunning\n• **Calangute**  -  lively, water sports, shacks\n• **Anjuna**  -  bohemian, flea markets, sunset parties\n\n🌴 **Kerala's Kovalam** and **Varkala** beach are also gorgeous, way less crowded!\n\nPrefer lively 🎉 or peaceful 🕊️?`,
      mountain: `${addr}the mountains are calling and you must go! ⛰️ (as Muir would say)\n\n🏔️ **Manali**  -  snow-capped peaks, Rohtang Pass, Beas valley  -  closest to nature\n🗻 **Ladakh**  -  5,000+ metre passes, Pangong's electric blue at altitude, raw Himalayas\n\nAre you a trekker 🥾 or more of a scenic road trip person 🚗?`,
    };
    return moods[mood] || respond('where should i go');
  }

  /* ── Smart recommendation based on memory ── */
  function smartRecommend() {
    const name = memory.name;

    // If we know a lot, give personalised pick
    if (memory.tripType && memory.mood) {
      const tt = TRIP_TYPES[memory.tripType];
      const city = tt.cities[0];
      const d = DEST[city];
      return `${name ? name + ', ' : ''}based on everything you've told me, I think **${d.name}** ${d.emoji} is your perfect match!\n\n${d.desc}\n\n💰 **Budget range:** ₹${d.budget.low.toLocaleString('en-IN')} – ₹${d.budget.high.toLocaleString('en-IN')}\n📅 **Go during:** ${d.season}\n\nWant me to show you the best packages and hotels for ${d.name}? 🎯`;
    }

    // Ask clarifying question
    if (!memory.tripType) {
      return `${name ? 'Hey ' + name + '! ' : ''}To give you the perfect recommendation, help me understand your trip better:\n\n👤 Are you travelling **solo**, with a **partner**, with **family**, or with **friends**?\n\n(Your answer completely changes my suggestion! 😊)`;
    }
    if (!memory.mood) {
      return `Almost there${name ? ', ' + name : ''}! What's your ideal travel vibe?\n\n🧗 **Adventure**  -  treks, rafting, skiing, biking\n🧘 **Relax & Wellness**  -  Ayurveda, spas, slow travel\n🏛️ **Culture & History**  -  forts, museums, local life\n🏖️ **Beach & Sun**  -  swimming, seafood, sunsets\n⛰️ **Mountains & Nature**  -  peaks, valleys, fresh air\n\nWhich speaks to you?`;
    }

    return `${name ? name + ', ' : ''}here are my top 3 picks for you:\n\n🥇 **Goa**  -  beaches, nightlife, amazing food\n🥈 **Kerala**  -  backwaters, Ayurveda, pure nature\n🥉 **Manali**  -  mountains, adventure, cosy vibes\n\nTell me more about your travel style and I'll give you a spot-on single recommendation! 🎯`;
  }

  /* ── Hotel response ── */
  function hotelResp(city, budget) {
    const d = DEST[city];
    const hotels = {
      goa:    { low:'Zostel Goa (₹799/night)  -  rooftop bar, social vibes, beach nearby', mid:'Lemon Tree Hotel (₹2,800/night)  -  pool, great breakfast', high:'The Leela Goa (₹9,500/night)  -  private beach, butler, pure luxury' },
      manali: { low:'Zostel Manali (₹899/night)  -  Old Manali, amazing cafe, trek community', mid:'Apple Country Resort (₹2,400/night)  -  orchards, bonfire, mountain views', high:'The Himalayan (₹5,500/night)  -  spa, fireplace, panoramic peaks' },
      jaipur: { low:'Hotel Pearl Palace (₹1,800/night)  -  rooftop cafe, heritage decor', mid:'Dera Mandawa Haveli (₹3,200/night)  -  authentic haveli architecture', high:'Rambagh Palace (₹18,000/night)  -  former royal residence, polo, butler' },
      kerala: { low:'Zostel Kochi (₹950/night)  -  Fort Kochi, charming heritage area', mid:'Green Woods Bethel Munnar (₹2,200/night)  -  tea garden views', high:'Kumarakom Lake Resort (₹9,800/night)  -  private pool villa, lake sunrises' },
      ladakh: { low:'Zostel Leh (₹1,100/night)  -  social, great for meeting other travellers', mid:'Hotel Singge Palace (₹2,600/night)  -  mountain views, reliable', high:'Chamba Camp Thiksey (₹8,200/night)  -  luxury tents, monastery view, spa' },
    };

    const h = hotels[city];
    if (!h) return `I can find great hotels in ${d.name}! What's your budget per night? 🏨`;

    if (budget && budget < 5000)  return `For **${d.name}** on a budget, I'd go with:\n\n💚 **${h.low}**\n\nGreat value and you'll meet amazing fellow travellers! Want me to tell you more about this property${memory.name ? ', ' + memory.name : ''}?`;
    if (budget && budget < 15000) return `For **${d.name}** in the mid-range, perfect pick:\n\n💛 **${h.mid}**\n\nComfort without overspending  -  exactly what you need! Shall I check what's included${memory.name ? ', ' + memory.name : ''}?`;
    if (budget && budget >= 15000) return `${memory.name ? memory.name + ', you' : 'You'} deserve the best! For **${d.name}** luxury:\n\n👑 **${h.high}**\n\nAbsolutely world-class. Every detail is taken care of. This one is unforgettable! 🌟`;

    return `For **${d.name}** ${d.emoji}, here are my picks across budgets:\n\n💚 **Budget:** ${h.low}\n💛 **Mid-range:** ${h.mid}\n👑 **Luxury:** ${h.high}\n\nWhat's your budget per night${memory.name ? ', ' + memory.name : ''}? I'll give you a precise recommendation!`;
  }

  /* ── Transport response ── */
  function transportResp(city) {
    const routes = {
      goa:    '✈️ **Flight Delhi→Goa**  -  IndiGo/SpiceJet from ₹3,200 (~2.5 hrs)\n✈️ **Flight Mumbai→Goa**  -  from ₹2,800 (~1 hr, quickest option!)\n🚂 **Train Mumbai→Goa**  -  from ₹900 (overnight, scenic coastal route)\n🚌 **Bus Bangalore→Goa**  -  ₹700 (overnight Kadamba/Volvo)',
      manali: '✈️ **Flight Delhi→Kullu**  -  Alliance Air from ₹5,500 (45 min, then taxi)\n🚌 **HRTC Volvo Delhi→Manali**  -  ₹850 (overnight ~14 hrs, most popular)\n🚌 **Bus Chandigarh→Manali**  -  ₹600 (7 hrs scenic Kullu valley)\n💡 *Pro tip: overnight Volvo bus is comfy AND saves a night\'s hotel!*',
      jaipur: '🚂 **Train Delhi→Jaipur**  -  Shatabdi ₹250 (4.5 hrs, fastest & most convenient!)\n✈️ **Flight Bangalore→Jaipur**  -  from ₹4,200 (2 hrs)\n🚌 **Bus Delhi→Jaipur**  -  RSRTC Volvo ₹450 (5 hrs)\n💡 *The train is the best option from Delhi  -  frequent and dead on time!*',
      kerala: '✈️ **Flight Delhi→Kochi**  -  IndiGo from ₹5,200 (3 hrs)\n✈️ **Flight Mumbai→Kochi**  -  from ₹3,800 (2 hrs)\n🚂 **Train Mumbai→Kerala**  -  ₹750 (30+ hrs, but scenic Kerala coast entry)\n🚌 **Bus Bangalore→Kerala**  -  KSRTC ₹650 (overnight)\n💡 *Flying into Kochi is usually the easiest gateway to Kerala!*',
      ladakh: '✈️ **Flight Delhi→Leh**  -  IndiGo from ₹7,500 (1.5 hrs, most practical)\n✈️ **Flight Mumbai→Leh**  -  from ₹9,200\n🚌 **Manali→Leh Highway Bus**  -  ₹550 (15–16 hrs on legendary mountain road!)\n🚌 **Srinagar→Leh**  -  JKSRTC ₹480 (2-day scenic route)\n💡 *The Manali–Leh bus journey itself is an experience  -  do it at least one way!*',
    };

    const d = DEST[city];
    return `Getting to **${d.name}** ${d.emoji}:\n\n${routes[city]}\n\nYou can search and book transport in our **Trip Planner**${memory.name ? ', ' + memory.name : ''}. Want me to help with hotels or packages for ${d.name} as well? 😊`;
  }

  /* ── Season tip ── */
  function seasonTip(city) {
    const tips = {
      goa:    '💡 The week between Christmas and New Year is the most lively (and expensive!) time in Goa. Book hotels 2–3 months ahead!',
      manali: '💡 If you want snow without freezing, early March is the sweet spot  -  snow still there, but daytime is pleasant!',
      jaipur: '💡 The Jaipur Literature Festival (Jan) and Jaipur Heritage Festival (Feb) are incredible if you can plan around them!',
      kerala: '💡 Monsoon (June–Aug) is actually a great time for Ayurveda treatments  -  the humidity enhances the therapy!',
      ladakh: '💡 Book your Leh flights 6–8 weeks ahead for summer  -  they sell out extremely fast! Acclimatise for 2 days before trekking.',
    };
    return tips[city] || '';
  }

  /* ── Follow up based on context ── */
  function followUp() {
    const city = memory.city;
    if (!city) return smartRecommend();
    const d = DEST[city];
    const options = [
      `Since you're interested in **${d.name}**, would you like to see:\n\n🏨 **Hotels**  -  from ₹${d.budget.low.toLocaleString('en-IN')}/night\n📦 **Packages**  -  all-inclusive deals\n🚀 **How to reach**  -  flights, trains, buses\n🍽️ **Local food tips**`,
      `Love that you're excited about **${d.name}** ${d.emoji}! Here's a little secret: ${d.hidden}\n\nShall I put together a full itinerary for you?`,
      `One more thing about **${d.name}**  -  ${d.food.split(',')[0]} is absolutely a must-try while you're there! 😋\n\nReady to start planning? Head to **Plan a Trip** and I'll guide you through it!`,
    ];
    return options[memory.msgCount % options.length];
  }

  /* ── Smart fallback ── */
  function smartFallback(_msg) {
    const name = memory.name;

    if (memory.city) {
      const d = DEST[memory.city];
      return `${name ? name + ', ' : ''}I want to make sure I give you the best answer! Could you rephrase that? 😊\n\nSince you're interested in **${d.name}**, I can tell you about:\n• 🏨 Hotels\n• 📦 Packages\n• 🚀 Transport\n• 🍽️ Food & hidden gems\n• 📅 Best time to visit`;
    }

    const suggestions = [
      `${name ? 'Hmm, ' + name + '! ' : 'Hmm! '}I didn't quite catch that 😊 Try asking something like:\n\n• *"Tell me about Goa"*\n• *"Best package for a couple under ₹20,000"*\n• *"When should I visit Ladakh?"*\n• *"Hotels in Kerala"*`,
      `I'm your India travel expert${name ? ', ' + name : ''}  -  so I'm best at helping with destinations, packages, hotels, transport and travel tips! Ask me anything about Indian travel 🗺️`,
    ];
    return suggestions[Math.floor(Math.random() * suggestions.length)];
  }

  /* ══════════════════════════════════════════
     UI
  ══════════════════════════════════════════ */
  const styles = `
    #yami-btn {
      position:fixed;bottom:28px;right:28px;z-index:10000;
      width:64px;height:64px;border-radius:50%;border:none;cursor:pointer;
      background:linear-gradient(135deg,#0CD4DE,#0096C7);
      box-shadow:0 8px 32px rgba(12,212,222,0.5);
      display:flex;align-items:center;justify-content:center;
      font-size:1.7rem;animation:yamiBobble 3s ease-in-out infinite;
    }
    @keyframes yamiBobble{0%,100%{transform:translateY(0) scale(1)}50%{transform:translateY(-7px) scale(1.06)}}
    #yami-btn:hover{transform:scale(1.13)!important;box-shadow:0 14px 44px rgba(12,212,222,0.65);animation:none}

    #yami-badge{
      position:absolute;top:-3px;right:-3px;
      width:20px;height:20px;border-radius:50%;
      background:linear-gradient(135deg,#F59E0B,#EF4444);border:2px solid #fff;
      font-size:0.62rem;font-weight:800;color:#fff;
      display:flex;align-items:center;justify-content:center;
      animation:badgePop 0.5s ease;
    }
    @keyframes badgePop{0%{transform:scale(0)}70%{transform:scale(1.3)}100%{transform:scale(1)}}

    #yami-window{
      position:fixed;bottom:108px;right:28px;z-index:9999;
      width:380px;max-height:580px;border-radius:24px;
      background:#fff;
      box-shadow:0 32px 80px rgba(0,0,0,0.16),0 0 0 1px rgba(12,212,222,0.18);
      display:flex;flex-direction:column;overflow:hidden;
      transform:scale(0.88) translateY(16px);opacity:0;
      transform-origin:bottom right;pointer-events:none;
      transition:transform 0.38s cubic-bezier(0.34,1.56,0.64,1),opacity 0.3s ease;
    }
    #yami-window.open{transform:scale(1) translateY(0);opacity:1;pointer-events:all}

    #yami-header{
      background:linear-gradient(135deg,#0CD4DE 0%,#0096C7 100%);
      padding:16px 18px;display:flex;align-items:center;gap:12px;flex-shrink:0;
    }
    #yami-avatar{
      width:44px;height:44px;border-radius:50%;
      background:rgba(255,255,255,0.22);
      display:flex;align-items:center;justify-content:center;
      font-size:1.35rem;flex-shrink:0;border:2px solid rgba(255,255,255,0.3);
      animation:avatarGlow 2.5s ease infinite;
    }
    @keyframes avatarGlow{0%,100%{box-shadow:0 0 0 0 rgba(255,255,255,0.4)}50%{box-shadow:0 0 0 9px rgba(255,255,255,0)}}
    #yami-title{flex:1}
    #yami-title h4{color:#fff;font-size:1rem;font-weight:700;margin:0;font-family:Inter,sans-serif;letter-spacing:-0.3px}
    #yami-title p{color:rgba(255,255,255,0.82);font-size:0.73rem;margin:2px 0 0;font-family:Inter,sans-serif}
    .yami-status-dot{display:inline-block;width:7px;height:7px;border-radius:50%;background:#4ADE80;margin-right:5px;animation:dotPulse2 1.5s ease infinite}
    @keyframes dotPulse2{0%,100%{opacity:1;transform:scale(1)}50%{opacity:0.6;transform:scale(1.5)}}
    #yami-close{
      background:rgba(255,255,255,0.18);border:none;color:#fff;
      width:32px;height:32px;border-radius:50%;cursor:pointer;font-size:1rem;
      display:flex;align-items:center;justify-content:center;transition:background 0.2s;flex-shrink:0;
    }
    #yami-close:hover{background:rgba(255,255,255,0.32)}

    #yami-messages{
      flex:1;overflow-y:auto;padding:14px 14px 8px;
      display:flex;flex-direction:column;gap:10px;scroll-behavior:smooth;
    }
    #yami-messages::-webkit-scrollbar{width:3px}
    #yami-messages::-webkit-scrollbar-thumb{background:rgba(12,212,222,0.35);border-radius:2px}

    .ymsg{display:flex;gap:8px;align-items:flex-end;animation:msgIn 0.32s ease}
    @keyframes msgIn{from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:translateY(0)}}
    .ymsg.user{flex-direction:row-reverse}

    .ybubble{
      max-width:80%;padding:10px 14px;border-radius:18px;
      font-family:Inter,sans-serif;font-size:0.83rem;line-height:1.58;
      white-space:pre-wrap;word-break:break-word;
    }
    .ymsg.bot  .ybubble{background:#EFF9FB;color:#0A2540;border-bottom-left-radius:4px;border:1px solid rgba(12,212,222,0.12)}
    .ymsg.user .ybubble{background:linear-gradient(135deg,#0CD4DE,#0096C7);color:#fff;border-bottom-right-radius:4px;box-shadow:0 4px 14px rgba(12,212,222,0.3)}

    .yavatar{
      width:30px;height:30px;border-radius:50%;flex-shrink:0;
      background:linear-gradient(135deg,#0CD4DE,#0096C7);
      display:flex;align-items:center;justify-content:center;font-size:0.9rem;
    }

    .ytyping{display:flex;gap:5px;padding:12px 14px;align-items:center}
    .ytyping span{width:8px;height:8px;border-radius:50%;background:#0CD4DE;animation:tdot 1.2s ease infinite}
    .ytyping span:nth-child(2){animation-delay:0.2s}
    .ytyping span:nth-child(3){animation-delay:0.4s}
    @keyframes tdot{0%,100%{transform:translateY(0);opacity:0.4}50%{transform:translateY(-7px);opacity:1}}

    #yami-quick{
      padding:8px 12px;display:flex;gap:6px;flex-wrap:wrap;flex-shrink:0;
      border-top:1px solid rgba(12,212,222,0.1);background:#FAFEFE;
    }
    .yqbtn{
      padding:5px 11px;border-radius:50px;
      border:1.5px solid rgba(12,212,222,0.35);
      background:transparent;color:#0096C7;
      font-size:0.72rem;font-weight:600;font-family:Inter,sans-serif;
      cursor:pointer;white-space:nowrap;transition:all 0.2s;
    }
    .yqbtn:hover{background:#0CD4DE;color:#fff;border-color:#0CD4DE;transform:scale(1.05)}

    #yami-input-wrap{
      display:flex;gap:8px;padding:10px 12px;flex-shrink:0;
      border-top:1px solid rgba(12,212,222,0.1);background:#fff;
    }
    #yami-input{
      flex:1;border:1.5px solid rgba(12,212,222,0.28);border-radius:50px;
      padding:9px 15px;font-family:Inter,sans-serif;font-size:0.84rem;
      outline:none;transition:border-color 0.2s;color:#0A2540;background:#fff;
    }
    #yami-input::placeholder{color:#9CA3AF}
    #yami-input:focus{border-color:#0CD4DE;box-shadow:0 0 0 3px rgba(12,212,222,0.1)}
    #yami-send{
      width:40px;height:40px;border-radius:50%;border:none;flex-shrink:0;
      background:linear-gradient(135deg,#0CD4DE,#0096C7);color:#fff;
      cursor:pointer;display:flex;align-items:center;justify-content:center;
      font-size:1rem;transition:transform 0.2s,box-shadow 0.2s;
    }
    #yami-send:hover{transform:scale(1.12);box-shadow:0 6px 20px rgba(12,212,222,0.45)}

    .ybubble strong{font-weight:700}
    .ybubble em{font-style:italic;opacity:0.85}

    @media(max-width:440px){
      #yami-window{width:calc(100vw - 24px);right:12px;bottom:96px}
    }
  `;

  const el = document.createElement('style');
  el.textContent = styles;
  document.head.appendChild(el);

  document.body.insertAdjacentHTML('beforeend', `
    <div id="yami-btn" onclick="yamiToggle()" title="Chat with Yami  -  AI Travel Assistant">
      🌊
      <div id="yami-badge" style="display:none">!</div>
    </div>
    <div id="yami-window">
      <div id="yami-header">
        <div id="yami-avatar">🌊</div>
        <div id="yami-title">
          <h4>Yami</h4>
          <p><span class="yami-status-dot"></span>AI Travel Assistant · Always here</p>
        </div>
        <button id="yami-close" onclick="yamiToggle()" title="Close">✕</button>
      </div>
      <div id="yami-messages"></div>
      <div id="yami-quick">
        <button class="yqbtn" onclick="yamiQ('Tell me about Goa')">🏖️ Goa</button>
        <button class="yqbtn" onclick="yamiQ('Recommend a honeymoon destination')">💕 Honeymoon</button>
        <button class="yqbtn" onclick="yamiQ('Best packages under 15000')">📦 Packages</button>
        <button class="yqbtn" onclick="yamiQ('I want an adventure trip')">🧗 Adventure</button>
        <button class="yqbtn" onclick="yamiQ('Solo trip ideas')">🎒 Solo</button>
        <button class="yqbtn" onclick="yamiQ('Luxury travel options')">👑 Luxury</button>
      </div>
      <div id="yami-input-wrap">
        <input id="yami-input" type="text" placeholder="Ask Yami anything about your trip..." autocomplete="off"/>
        <button id="yami-send" onclick="yamiSend()" title="Send">➤</button>
      </div>
    </div>
  `);

  const win   = document.getElementById('yami-window');
  const msgs  = document.getElementById('yami-messages');
  const inp   = document.getElementById('yami-input');
  const badge = document.getElementById('yami-badge');
  let isOpen  = false;
  let opened  = false;

  window.yamiToggle = function () {
    isOpen = !isOpen;
    win.classList.toggle('open', isOpen);
    if (isOpen) {
      badge.style.display = 'none';
      if (!opened) {
        opened = true;
        const greeting = `${timeGreeting()}! 🌊 I'm **Yami**, your personal WanderWise travel guide!\n\nBefore we dive into planning your dream trip  -  what's your name? I'd love to make this feel personal 😊`;
        delay(() => botMsg(greeting), 450);
      }
      delay(() => inp.focus(), 400);
    }
  };

  window.yamiSend = function () {
    const txt = inp.value.trim();
    if (!txt) return;
    userMsg(txt);
    inp.value = '';
    typing();
    delay(() => { stopTyping(); botMsg(respond(txt)); }, 800 + Math.random() * 700);
  };

  window.yamiQ = function (txt) {
    userMsg(txt);
    typing();
    delay(() => { stopTyping(); botMsg(respond(txt)); }, 700 + Math.random() * 500);
  };

  function userMsg(txt) {
    const d = document.createElement('div');
    d.className = 'ymsg user';
    d.innerHTML = `<div class="ybubble">${esc(txt)}</div>`;
    msgs.appendChild(d); scrollEnd();
  }

  function botMsg(txt) {
    const d = document.createElement('div');
    d.className = 'ymsg bot';
    d.innerHTML = `<div class="yavatar">🌊</div><div class="ybubble">${fmt(txt)}</div>`;
    msgs.appendChild(d); scrollEnd();
  }

  let typEl = null;
  function typing() {
    typEl = document.createElement('div');
    typEl.className = 'ymsg bot';
    typEl.innerHTML = `<div class="yavatar">🌊</div><div class="ybubble ytyping"><span></span><span></span><span></span></div>`;
    msgs.appendChild(typEl); scrollEnd();
  }
  function stopTyping() { if (typEl) { typEl.remove(); typEl = null; } }

  function scrollEnd() { msgs.scrollTop = msgs.scrollHeight; }
  function delay(fn, ms) { setTimeout(fn, ms); }
  function esc(t) { return t.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }
  function fmt(t) {
    return esc(t)
      .replace(/\*\*(.*?)\*\*/g,'<strong>$1</strong>')
      .replace(/\*(.*?)\*/g,'<em>$1</em>')
      .replace(/\n/g,'<br/>');
  }

  inp.addEventListener('keydown', e => { if (e.key === 'Enter' && !e.shiftKey) window.yamiSend(); });

  // Show badge after 4s
  delay(() => { if (!isOpen) { badge.style.display = 'flex'; } }, 4000);

})();
