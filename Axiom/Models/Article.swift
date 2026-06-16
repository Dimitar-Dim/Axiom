import Foundation

struct Article: Identifiable, Equatable {
    let id = UUID()
    let headline: String
    let publisher: String
    let tags: [String]
    let publishedAt: String
    let body: String
    let imageURL: String
    let location: String?
    let url: String?

    init(headline: String, publisher: String, tags: [String], publishedAt: String, body: String, imageURL: String, location: String? = nil, url: String? = nil) {
        self.headline = headline
        self.publisher = publisher
        self.tags = tags
        self.publishedAt = publishedAt
        self.body = body
        self.imageURL = imageURL
        self.location = location
        self.url = url
    }
}

extension Article {
    static let samples: [Article] = global + netherlands + uk + usa + germany + france + geopolitics + india + china + brazil + japan + australia

    static func articleCount(forTag tag: String) -> Int {
        samples.filter { $0.tags.contains(tag) }.count
    }

    static func articleCount(forPublisher publisher: String) -> Int {
        samples.filter { $0.publisher == publisher }.count
    }

    // MARK: – Global / No Location
    static let global: [Article] = [
        Article(
            headline: "The Future of Artificial Intelligence in Healthcare",
            publisher: "MIT Review",
            tags: ["AI", "Health", "Tech"],
            publishedAt: "2h ago",
            body: "Artificial intelligence is no longer a distant promise in medicine. Hospitals across the United States are now using AI-powered diagnostic tools to detect conditions like diabetic retinopathy and certain cancers with accuracy rates that match or exceed human specialists.\n\nThe implications are significant. In regions where specialist access is limited, AI could serve as a first-line diagnostic layer, triaging patients before they ever see a doctor. Researchers at MIT and Stanford are already publishing studies showing meaningful reductions in misdiagnosis rates.\n\nThe challenge ahead is not technological — it is regulatory and ethical. Questions around liability, data privacy, and algorithmic bias remain largely unsettled, and healthcare systems will need to address all three before AI becomes standard practice.",
            imageURL: "https://picsum.photos/seed/healthcare/800/500"
        ),
        Article(
            headline: "AI-Powered Drug Discovery Enters Clinical Trials",
            publisher: "MIT Review",
            tags: ["AI", "Health", "Science"],
            publishedAt: "5h ago",
            body: "A pharmaceutical startup backed by DeepMind researchers has announced that its AI-designed compound targeting treatment-resistant depression has entered Phase 1 clinical trials. The compound was identified in under eight months — a process that would traditionally take three to five years.\n\nThe model behind the discovery was trained on protein structure databases and existing clinical trial data, allowing it to predict molecular behaviour with unusual precision. Early results in animal models were described as promising by the trial's lead investigator.\n\nIf the trials succeed, it would mark one of the first drugs brought to human testing that was both discovered and optimised entirely by an AI system.",
            imageURL: "https://picsum.photos/seed/laboratory/800/500"
        ),
        Article(
            headline: "Climate Change and Its Economic Impact on Global Markets",
            publisher: "The Economist",
            tags: ["Climate", "Economy", "Policy"],
            publishedAt: "4h ago",
            body: "The economic cost of climate change is no longer a projection — it is a present reality showing up in insurance markets, agricultural yields, and infrastructure spending. Swiss Re estimates that natural catastrophe losses exceeded $280 billion in 2025, the third consecutive year above that threshold.\n\nFinancial markets are beginning to price in physical risk more explicitly. Coastal real estate in Florida and parts of Southeast Asia has seen insurance premiums spike by as much as 40% in two years, with some insurers withdrawing from regions entirely.\n\nPolicymakers face a compounding challenge: the transition to clean energy requires enormous capital investment at precisely the moment that climate-related damage is straining public budgets.",
            imageURL: "https://picsum.photos/seed/climate/800/500"
        ),
        Article(
            headline: "The Global Energy Transition Is Rewriting Geopolitics",
            publisher: "The Economist",
            tags: ["Climate", "Policy", "Science"],
            publishedAt: "7h ago",
            body: "The shift away from fossil fuels is redrawing the map of global influence. Countries that built their foreign policy leverage on oil and gas exports — Saudi Arabia, Russia, and the Gulf states — are watching that leverage erode as renewable capacity scales in Europe, China, and North America.\n\nAt the same time, a new set of dependencies is emerging. Critical minerals like lithium, cobalt, and rare earth elements are concentrated in a small number of countries, creating fresh vulnerabilities for nations racing to electrify their economies.",
            imageURL: "https://picsum.photos/seed/solarenergy/800/500"
        ),
        Article(
            headline: "SwiftUI 6: What's New for Apple Developers This Fall",
            publisher: "Swift Blog",
            tags: ["Swift", "iOS", "Dev"],
            publishedAt: "6h ago",
            body: "Apple's SwiftUI 6 release brings a set of changes that developers have been requesting for years. The most significant is a redesigned animation system that gives developers fine-grained control over spring parameters without needing to drop into UIKit.\n\nFor teams working on larger apps, the improvements to @Observable and the new structured concurrency hooks in the view lifecycle are the changes most likely to have a lasting impact on how SwiftUI codebases are organised.",
            imageURL: "https://picsum.photos/seed/applecode/800/500"
        ),
        Article(
            headline: "Async/Await in Practice: Real-World SwiftUI Patterns",
            publisher: "Swift Blog",
            tags: ["Swift", "iOS", "Dev"],
            publishedAt: "10h ago",
            body: "Swift's async/await syntax has been available since Swift 5.5, but many teams are still working out how to integrate it cleanly into SwiftUI apps. The main tension is between SwiftUI's declarative, state-driven model and the imperative nature of async code.\n\nThe pattern that has emerged in most production codebases is to confine async work to view models or dedicated actor types, keeping views themselves free of Task creation and cancellation logic.",
            imageURL: "https://picsum.photos/seed/swift-dev/800/500"
        ),
        Article(
            headline: "SpaceX Starship's Latest Mission Breaks Records",
            publisher: "Space.com",
            tags: ["Space", "Science"],
            publishedAt: "8h ago",
            body: "SpaceX's Starship completed its seventh integrated flight test, achieving a successful booster catch at the launch site for the second time and reaching a peak altitude of 210 kilometres — the highest the vehicle has flown to date.\n\nNASA, which has contracted Starship as the Human Landing System for its Artemis moon missions, said it was reviewing the flight data before its next programme milestone review.",
            imageURL: "https://picsum.photos/seed/rocketlaunch/800/500"
        ),
        Article(
            headline: "James Webb Telescope Captures Earliest Galaxies Ever Seen",
            publisher: "Space.com",
            tags: ["Space", "Science", "Tech"],
            publishedAt: "1d ago",
            body: "Astronomers using the James Webb Space Telescope have confirmed the observation of two galaxies dating to approximately 290 million years after the Big Bang — the earliest structures ever directly imaged.\n\nThe galaxies are smaller and more compact than anything visible in the Hubble Ultra Deep Field, with stellar masses roughly 100 times lower than the Milky Way. Their discovery challenges existing models of early universe structure formation.",
            imageURL: "https://picsum.photos/seed/galaxy-deep/800/500"
        ),
        Article(
            headline: "Inside the Rise of Decentralised Finance",
            publisher: "Bloomberg",
            tags: ["DeFi", "Crypto", "Finance"],
            publishedAt: "1d ago",
            body: "Decentralised finance has matured significantly since the collapse of several high-profile protocols in 2022. Total value locked across major DeFi platforms has recovered to levels not seen since early 2021.\n\nThe recovery has been driven largely by institutional interest in on-chain lending and yield products, rather than the retail speculation that characterised the earlier cycle.",
            imageURL: "https://picsum.photos/seed/blockchain/800/500"
        ),
        Article(
            headline: "Bitcoin ETFs Hit Record Inflows as Institutions Pile In",
            publisher: "Bloomberg",
            tags: ["Finance", "Crypto", "Economy"],
            publishedAt: "2d ago",
            body: "US spot Bitcoin ETFs recorded their highest ever single-week inflow, with net purchases across all approved products exceeding $4.1 billion. BlackRock's iShares Bitcoin Trust alone accounted for more than half of the total.\n\nRetail participation remains subdued relative to institutional flows — a structural shift that many in the industry see as a sign of the asset class maturing.",
            imageURL: "https://picsum.photos/seed/wallstreet/800/500"
        ),
        Article(
            headline: "How Quantum Computing Will Transform Cybersecurity",
            publisher: "Wired",
            tags: ["Quantum", "Security", "Tech"],
            publishedAt: "1d ago",
            body: "The cybersecurity industry is preparing for a threat that does not yet exist at scale: a cryptographically relevant quantum computer capable of breaking RSA and elliptic curve encryption. Most experts put that timeline at ten to fifteen years — but preparation needs to start now.\n\nThe more immediate risk is harvest-now-decrypt-later attacks, in which adversaries collect encrypted data today with the intent to decrypt it once quantum capability matures.",
            imageURL: "https://picsum.photos/seed/cybersecurity/800/500"
        ),
        Article(
            headline: "The AI Arms Race: Big Tech's Battle for Supremacy",
            publisher: "Wired",
            tags: ["AI", "Tech", "Policy"],
            publishedAt: "2d ago",
            body: "The competition between Google, Microsoft, Meta, and Amazon to dominate artificial intelligence has entered a phase defined less by model benchmarks and more by infrastructure. Each company is now spending tens of billions annually on data centres, custom silicon, and energy supply agreements.\n\nFor regulators, the concentration of AI capability is becoming as much a concern as the risks of the technology itself.",
            imageURL: "https://picsum.photos/seed/bigtech/800/500"
        ),
        Article(
            headline: "OpenAI Releases Next-Generation Reasoning Model",
            publisher: "TechCrunch",
            tags: ["AI", "Tech"],
            publishedAt: "3h ago",
            body: "OpenAI has released its most capable reasoning model to date, demonstrating significant improvements on graduate-level science benchmarks and multi-step mathematical problem solving. The model is available via API to enterprise customers immediately.\n\nThe release intensifies competition with Google's Gemini Ultra and Anthropic's Claude, both of which have released their own reasoning-focused updates within the past month.",
            imageURL: "https://picsum.photos/seed/openai-model/800/500"
        ),
        Article(
            headline: "Meta Launches Mixed Reality Glasses With Built-In AI Assistant",
            publisher: "The Verge",
            tags: ["AI", "Tech"],
            publishedAt: "5h ago",
            body: "Meta has announced the second generation of its Ray-Ban smart glasses, now featuring a front-facing camera with real-time AI scene understanding and a persistent assistant that remembers context across sessions.\n\nThe device represents Meta's clearest bet yet that ambient AI wearables will reach mainstream adoption before dedicated AR headsets. Early reviewers described the assistant as genuinely useful for navigation and quick lookups.",
            imageURL: "https://picsum.photos/seed/wearable-tech/800/500"
        ),
        Article(
            headline: "Breakthrough in Room-Temperature Superconductivity Confirmed",
            publisher: "Nature",
            tags: ["Science", "Tech"],
            publishedAt: "1d ago",
            body: "A team at the University of Rochester has published peer-reviewed results confirming stable superconductivity in a hydrogen-rich compound at room temperature and near-ambient pressure. Three independent labs have replicated the core finding.\n\nIf the material can be synthesised at scale, it could eliminate resistive losses in power transmission — the most significant practical development in energy infrastructure in decades.",
            imageURL: "https://picsum.photos/seed/laboratory-science/800/500"
        ),
        Article(
            headline: "Global Data Centre Energy Consumption Doubles in Five Years",
            publisher: "Wired",
            tags: ["Tech", "Climate", "Energy"],
            publishedAt: "2d ago",
            body: "A report from the International Energy Agency estimates that data centres now account for 3.5% of global electricity consumption, up from 1.5% five years ago. AI training workloads are identified as the primary driver of the acceleration.\n\nSeveral hyperscalers have responded by signing long-term contracts for nuclear and offshore wind power, though critics argue the timelines do not match the pace at which demand is growing.",
            imageURL: "https://picsum.photos/seed/datacenter/800/500"
        ),
        Article(
            headline: "WHO Declares Mpox Outbreak Contained After Vaccination Drive",
            publisher: "Reuters",
            tags: ["Health", "Science"],
            publishedAt: "3d ago",
            body: "The World Health Organization has declared the 2025 mpox outbreak contained following a six-month vaccination campaign that reached 12 million people across central and east Africa. The campaign was described as the fastest vaccine rollout in African Union history.\n\nOfficials cautioned that containment does not mean elimination, and that ongoing surveillance would continue through the end of the year.",
            imageURL: "https://picsum.photos/seed/vaccination/800/500"
        ),
        Article(
            headline: "Fusion Energy Milestone: ITER Achieves First Plasma",
            publisher: "Nature",
            tags: ["Science", "Energy"],
            publishedAt: "4d ago",
            body: "ITER, the international fusion reactor under construction in southern France, achieved first plasma on schedule — a milestone that marks the transition from construction to experimental operations. The plasma lasted 11 seconds at a temperature of 100 million degrees Celsius.\n\nCommercial fusion power remains at least a decade away from ITER's programme, but the milestone is significant for validating the engineering assumptions behind the project.",
            imageURL: "https://picsum.photos/seed/fusion-reactor/800/500"
        ),
        Article(
            headline: "Cybersecurity Breach Exposes 2 Billion Records Across 40 Companies",
            publisher: "Wired",
            tags: ["Security", "Tech"],
            publishedAt: "1d ago",
            body: "A coordinated intrusion campaign linked to a state-affiliated group has exposed personal and financial records across 40 companies in the financial services and healthcare sectors. The breach is considered the largest coordinated data exposure since 2021.\n\nSecurity researchers say the attack exploited a zero-day vulnerability in a widely used identity management library that had been unpatched for nine months despite a known proof-of-concept.",
            imageURL: "https://picsum.photos/seed/hacker/800/500"
        ),
        Article(
            headline: "New Battery Technology Promises 1,000km EV Range",
            publisher: "MIT Review",
            tags: ["Tech", "Energy", "Science"],
            publishedAt: "2d ago",
            body: "Researchers at MIT have demonstrated a solid-state battery cell achieving an energy density of 500 Wh/kg — more than double current lithium-ion cells — in conditions compatible with automotive manufacturing processes.\n\nThe team projects that the technology could reach commercial production within four years. At that energy density, a midsize electric vehicle could achieve a real-world range of approximately 1,000 kilometres on a single charge.",
            imageURL: "https://picsum.photos/seed/battery-ev/800/500"
        ),
        Article(
            headline: "Social Media Algorithms Found to Amplify Misinformation Sixfold",
            publisher: "Nature",
            tags: ["Tech", "Policy", "Science"],
            publishedAt: "3d ago",
            body: "A large-scale study published in Nature has found that engagement-optimised recommendation algorithms amplify misinformation at six times the rate of accurate content, even after controlling for initial posting volume and user network effects.\n\nThe findings have renewed calls for algorithmic transparency legislation in the EU and United States, with lawmakers citing the study in hearings on platform accountability.",
            imageURL: "https://picsum.photos/seed/social-media/800/500"
        ),
        Article(
            headline: "Apple Intelligence Expands to 40 New Languages",
            publisher: "The Verge",
            tags: ["AI", "iOS", "Tech"],
            publishedAt: "6h ago",
            body: "Apple has released an update extending its on-device AI features to 40 additional languages, including Arabic, Dutch, Polish, and several South Asian language families. The expansion uses a compressed model architecture that fits within the memory constraints of iPhone 15 and newer.\n\nThe on-device approach stands in contrast to competitors who route most inference through cloud servers, and Apple has emphasised the privacy benefits in its marketing.",
            imageURL: "https://picsum.photos/seed/apple-ai/800/500"
        ),
        Article(
            headline: "New iOS Features for Developers: WWDC 2026 Recap",
            publisher: "Swift Blog",
            tags: ["Swift", "iOS", "Dev"],
            publishedAt: "1d ago",
            body: "Apple's developer conference introduced a range of new APIs including a redesigned HealthKit integration, real-time transcription hooks, and improvements to the Vision framework for spatial computing. The conference also confirmed that Swift 6 strict concurrency will be required for all new App Store submissions from 2027.\n\nFor developers, the most anticipated addition is the new declarative intent system that replaces App Intents boilerplate with a macro-based approach.",
            imageURL: "https://picsum.photos/seed/wwdc/800/500"
        ),
    ]

    // MARK: – Netherlands
    static let netherlands: [Article] = [
        Article(
            headline: "Dutch Coalition Government Forms After Months of Negotiations",
            publisher: "NRC",
            tags: ["Politics", "Policy"],
            publishedAt: "4h ago",
            body: "The Netherlands has a new four-party coalition government after 210 days of formation talks — the second longest in Dutch history. The coalition agreement centres on housing reform, nitrogen reduction targets, and a freeze on income tax thresholds.\n\nThe new cabinet faces an immediate challenge in reconciling the diverging positions of its parties on asylum policy, which was the main sticking point throughout the negotiations.",
            imageURL: "https://picsum.photos/seed/dutch-parliament/800/500",
            location: "Netherlands"
        ),
        Article(
            headline: "Amsterdam Introduces Congestion Pricing for City Centre",
            publisher: "De Telegraaf",
            tags: ["Transport", "Policy"],
            publishedAt: "2h ago",
            body: "Amsterdam has become the second Dutch city after Rotterdam to introduce road pricing in its historic centre, charging drivers €3 per entry during peak hours. The scheme is expected to reduce car traffic by 25% and generate €80 million annually for cycling infrastructure.\n\nBusiness owners in the centre are divided. Restaurant associations predict a 15% drop in footfall, while retailers near metro stations expect the opposite effect.",
            imageURL: "https://picsum.photos/seed/amsterdam-bike/800/500",
            location: "Amsterdam, Netherlands"
        ),
        Article(
            headline: "ASML Reports Record Earnings as Global Chip Demand Surges",
            publisher: "Financial Times",
            tags: ["Finance", "Tech", "Business"],
            publishedAt: "3h ago",
            body: "ASML, the Dutch semiconductor equipment maker and the only company capable of producing extreme ultraviolet lithography machines, reported quarterly revenues of €8.2 billion — a 34% increase year-on-year. Order backlog now stands at €39 billion.\n\nDemand is being driven equally by AI infrastructure buildout and the ongoing diversification of chip manufacturing away from Taiwan. ASML has indicated it cannot expand capacity fast enough to meet current demand.",
            imageURL: "https://picsum.photos/seed/semiconductor/800/500",
            location: "Eindhoven, Netherlands"
        ),
        Article(
            headline: "Netherlands Announces 2GW Offshore Wind Expansion in North Sea",
            publisher: "NRC",
            tags: ["Climate", "Energy", "Policy"],
            publishedAt: "6h ago",
            body: "The Dutch government has approved two new offshore wind zones in the North Sea with a combined capacity of 2 gigawatts, bringing total planned offshore capacity to 21GW by 2030. The zones are expected to power 2.5 million homes.\n\nEnvironmental groups broadly welcomed the announcement but raised concerns about the impact on migratory bird routes through the central North Sea corridor.",
            imageURL: "https://picsum.photos/seed/windmills-sea/800/500",
            location: "Netherlands"
        ),
        Article(
            headline: "Rotterdam Port Tests Hydrogen-Powered Cargo Ships",
            publisher: "Reuters",
            tags: ["Energy", "Transport", "Climate"],
            publishedAt: "8h ago",
            body: "The Port of Rotterdam has launched a six-month pilot of two hydrogen fuel cell cargo vessels operating short-haul routes to Antwerp and Hamburg. The vessels were developed by a Dutch-German consortium and use green hydrogen produced at the port's electrolysis facility.\n\nIf the pilot meets efficiency targets, Rotterdam intends to mandate zero-emission propulsion for all vessels under 5,000 tonnes operating within the port by 2030.",
            imageURL: "https://picsum.photos/seed/rotterdam-port/800/500",
            location: "Rotterdam, Netherlands"
        ),
        Article(
            headline: "Dutch Housing Crisis Worsens as Rents Hit Record Highs",
            publisher: "NU.nl",
            tags: ["Society", "Policy"],
            publishedAt: "1h ago",
            body: "Average private sector rents in the four largest Dutch cities have risen 18% in the past year, with Amsterdam median rents now exceeding €1,900 per month for a two-bedroom apartment. The shortage of social housing is at its widest since records began in 1985.\n\nThe new coalition has promised to build 100,000 homes per year, though planning experts say nitrogen emission regulations continue to block approximately 40% of approved construction projects.",
            imageURL: "https://picsum.photos/seed/dutch-housing/800/500",
            location: "Netherlands"
        ),
        Article(
            headline: "Eindhoven Tech Hub Attracts €500M in Startup Investment This Quarter",
            publisher: "De Telegraaf",
            tags: ["Business", "Tech"],
            publishedAt: "5h ago",
            body: "The Brainport Eindhoven region has attracted €500 million in venture capital investment in a single quarter for the first time, driven by spin-offs from ASML, Philips, and NXP Semiconductors. The region now has more active tech startups per capita than Amsterdam.\n\nMunicipal authorities have approved a €200 million expansion of the High Tech Campus, which already hosts over 300 companies and 15,000 researchers.",
            imageURL: "https://picsum.photos/seed/tech-campus/800/500",
            location: "Eindhoven, Netherlands"
        ),
        Article(
            headline: "Dutch Farmers Protest Nitrogen Emission Rules in The Hague",
            publisher: "Reuters",
            tags: ["Politics", "Climate", "Society"],
            publishedAt: "3h ago",
            body: "Thousands of farmers drove tractors into The Hague for the third time this year to protest mandatory nitrogen reduction targets that the government says require cutting livestock numbers by up to 30% in designated nature zones.\n\nThe demonstrations have paralysed parts of the city centre and revived a political debate that has already brought down one government. The farmers' movement BoerBurgerBeweging (BBB) has indicated it will escalate action if the new cabinet does not reopen negotiations.",
            imageURL: "https://picsum.photos/seed/farm-protest/800/500",
            location: "The Hague, Netherlands"
        ),
        Article(
            headline: "Ajax Rebuilds With New Technical Director After Turbulent Season",
            publisher: "De Telegraaf",
            tags: ["Sports", "Business"],
            publishedAt: "2d ago",
            body: "Ajax Amsterdam has appointed a new technical director from Feyenoord's academy system as the club attempts to stabilise after a season that saw three coaches and a relegation battle that was ultimately avoided on the final matchday.\n\nThe appointment is part of a broader restructuring that includes a revised scouting model focusing on the Eredivisie and Belgian Pro League, moving away from the expensive transfer strategy that contributed to the financial difficulties of recent years.",
            imageURL: "https://picsum.photos/seed/football-stadium/800/500",
            location: "Amsterdam, Netherlands"
        ),
        Article(
            headline: "TU Delft Develops AI Chip That Outperforms Nvidia in Efficiency",
            publisher: "NRC",
            tags: ["AI", "Tech", "Science"],
            publishedAt: "1d ago",
            body: "Researchers at Delft University of Technology have demonstrated a neuromorphic AI chip that performs inference tasks at 40 times the energy efficiency of comparable Nvidia hardware, using a novel photonic interconnect architecture.\n\nThe chip is not yet ready for mass production, but the research has attracted interest from IMEC and three major semiconductor manufacturers. The team expects a commercial partnership within 18 months.",
            imageURL: "https://picsum.photos/seed/microchip/800/500",
            location: "Delft, Netherlands"
        ),
        Article(
            headline: "Netherlands to Phase Out Natural Gas by 2030 Ahead of EU Deadline",
            publisher: "Financial Times",
            tags: ["Energy", "Policy", "Climate"],
            publishedAt: "2d ago",
            body: "The Dutch government has brought forward its target for ending residential natural gas connections to 2030, two years earlier than the EU's directive requires. The decision affects 5.6 million homes and requires an estimated €45 billion in heat pump subsidies and grid upgrades.\n\nThe announcement follows the final closure of the Groningen gas field last year and the government's assessment that dependence on imported LNG presents a long-term strategic risk.",
            imageURL: "https://picsum.photos/seed/dutch-energy/800/500",
            location: "Netherlands"
        ),
        Article(
            headline: "Dutch Pension Funds Shift €200B Into Sustainable Assets",
            publisher: "Bloomberg",
            tags: ["Finance", "Climate"],
            publishedAt: "3d ago",
            body: "ABP and PFZW, the two largest Dutch pension funds with combined assets of over €700 billion, have completed the reallocation of €200 billion into sustainable investment categories, meeting targets set in their 2021 climate commitments three years ahead of schedule.\n\nThe move represents the largest single climate-aligned capital reallocation in European pension fund history and is expected to influence allocation decisions at pension funds across the continent.",
            imageURL: "https://picsum.photos/seed/pension-invest/800/500",
            location: "Netherlands"
        ),
        Article(
            headline: "Schiphol Capacity Limits Extended Despite Airline Pushback",
            publisher: "Reuters",
            tags: ["Transport", "Business", "Policy"],
            publishedAt: "1d ago",
            body: "The Dutch government has extended Schiphol Airport's annual capacity cap of 440,000 flight movements for another three years, rejecting appeals from KLM and Ryanair who argued the restriction costs the Netherlands €1.2 billion annually in lost aviation activity.\n\nThe decision was upheld by the Council of State, which found that noise and nitrogen emission standards near the airport continue to require the cap under European environmental law.",
            imageURL: "https://picsum.photos/seed/schiphol/800/500",
            location: "Amsterdam, Netherlands"
        ),
        Article(
            headline: "Philips Restructures Healthcare Division Amid Profit Warnings",
            publisher: "Bloomberg",
            tags: ["Business", "Health", "Finance"],
            publishedAt: "5h ago",
            body: "Royal Philips has announced the separation of its sleep and respiratory care division into a standalone entity, following four consecutive quarters of revenue decline attributed to ongoing recall costs related to its CPAP ventilator machines.\n\nThe restructuring is the most significant since Philips sold its lighting division in 2016. Analysts at ING say the move is necessary to protect the higher-margin imaging and patient monitoring businesses from continued recall litigation.",
            imageURL: "https://picsum.photos/seed/medical-device/800/500",
            location: "Amsterdam, Netherlands"
        ),
        Article(
            headline: "Netherlands Leads EU in EV Adoption Rate for Second Year",
            publisher: "NRC",
            tags: ["Transport", "Climate", "Policy"],
            publishedAt: "4h ago",
            body: "New vehicle registration data shows the Netherlands with an electric vehicle share of 38% of new car sales in the first half of the year — the highest in the European Union and well above the EU average of 22%. The figure is driven by a combination of fiscal incentives and one of Europe's densest public charging networks.\n\nThe Netherlands now has one public charging point per 4.2 EVs on the road, compared to a European average of one per 12.",
            imageURL: "https://picsum.photos/seed/electric-car/800/500",
            location: "Netherlands"
        ),
    ]

    // MARK: – United Kingdom
    static let uk: [Article] = [
        Article(
            headline: "UK General Election Results Reshape Parliament",
            publisher: "BBC",
            tags: ["Politics", "Policy"],
            publishedAt: "1d ago",
            body: "The United Kingdom's general election has produced a hung parliament for the first time since 2010, with no single party securing the 326 seats needed for a majority. Coalition talks are expected to take weeks.\n\nThe result reflects deep fragmentation in the electorate across issues of economic management, NHS funding, and immigration — with smaller parties collectively winning their largest share of the popular vote in modern history.",
            imageURL: "https://picsum.photos/seed/uk-parliament/800/500",
            location: "London, UK"
        ),
        Article(
            headline: "Bank of England Holds Rates as Inflation Cools to 2.1%",
            publisher: "Financial Times",
            tags: ["Finance", "Economy"],
            publishedAt: "6h ago",
            body: "The Bank of England's Monetary Policy Committee voted 7-2 to hold the base rate at 4.75%, citing persistent services inflation and wage growth that remains above target. Two members argued for a 25 basis point cut.\n\nGovernor Andrew Bailey indicated that the committee expects to begin a gradual easing cycle in the second half of the year if current trends continue, though he emphasised that decisions will remain data-dependent.",
            imageURL: "https://picsum.photos/seed/bank-england/800/500",
            location: "London, UK"
        ),
        Article(
            headline: "NHS Announces AI Diagnostic Pilot Across 50 Hospitals",
            publisher: "BBC",
            tags: ["Health", "AI", "Policy"],
            publishedAt: "8h ago",
            body: "NHS England has launched a two-year pilot of AI-assisted diagnosis across 50 hospitals, covering radiology, pathology, and emergency triage. The programme is the largest public health AI deployment in Europe by patient volume.\n\nThe AI systems are trained on NHS data and validated to UK clinical standards. Results will be reviewed by a human clinician before any diagnosis is confirmed, and the programme includes a real-world evidence framework to monitor outcomes.",
            imageURL: "https://picsum.photos/seed/nhs-hospital/800/500",
            location: "UK"
        ),
        Article(
            headline: "London Tech Sector Raises Record £18B in Single Quarter",
            publisher: "Reuters",
            tags: ["Business", "Tech", "Finance"],
            publishedAt: "2d ago",
            body: "London's technology sector raised £18 billion in venture and growth capital in the first quarter, surpassing its previous single-quarter record and cementing the city's position as the leading tech funding destination in Europe.\n\nFintech and AI startups accounted for two thirds of the total, with several late-stage rounds above £500 million. Investors from the US and Middle East were the largest sources of capital.",
            imageURL: "https://picsum.photos/seed/london-city/800/500",
            location: "London, UK"
        ),
        Article(
            headline: "Scotland Votes on Independence Referendum Bill",
            publisher: "BBC",
            tags: ["Politics", "Policy"],
            publishedAt: "3h ago",
            body: "The Scottish Parliament has passed a bill calling for a second independence referendum by 69 votes to 58, though legal experts say the legislation will face immediate challenge in the UK Supreme Court over competency.\n\nThe Scottish government argues that the 2014 vote result has been invalidated by Brexit, which Scotland voted against by 62%. Westminster has reiterated that it will not grant a Section 30 order authorising the referendum.",
            imageURL: "https://picsum.photos/seed/scotland/800/500",
            location: "Edinburgh, UK"
        ),
        Article(
            headline: "UK Signs Landmark Trade Deal With India After Three Years",
            publisher: "Reuters",
            tags: ["Economy", "Policy"],
            publishedAt: "1d ago",
            body: "The United Kingdom and India have finalised a free trade agreement that reduces tariffs on 90% of UK goods exported to India and grants Indian professionals easier access to UK work visas in the tech and medical sectors.\n\nThe deal is the UK's most significant post-Brexit trade agreement by GDP of partner country, though critics note that service sector access — the UK's main export strength — is more limited than originally sought.",
            imageURL: "https://picsum.photos/seed/trade-deal/800/500",
            location: "UK"
        ),
        Article(
            headline: "Heathrow Third Runway Gets Final Planning Approval",
            publisher: "The Guardian",
            tags: ["Transport", "Policy", "Business"],
            publishedAt: "2d ago",
            body: "Heathrow Airport's third runway has received its final planning consent after a legal challenge by environmental groups was rejected by the Court of Appeal. Construction is expected to begin in 2027, with the runway operational by 2034.\n\nThe decision ends a debate that has run for over thirty years. Opponents have vowed to pursue a Supreme Court challenge, though legal observers give it limited prospect of success given the Court of Appeal's detailed reasoning.",
            imageURL: "https://picsum.photos/seed/heathrow/800/500",
            location: "London, UK"
        ),
        Article(
            headline: "British Steel Nationalised to Prevent Closure of Scunthorpe Plant",
            publisher: "Reuters",
            tags: ["Business", "Politics", "Policy"],
            publishedAt: "4h ago",
            body: "The UK government has nationalised British Steel in an emergency move to prevent the imminent closure of the Scunthorpe steelworks, which employs 4,500 people and is one of the last two integrated blast furnace steel plants in the country.\n\nThe Chinese owner Jingye had given notice that it would cease operations within weeks due to losses. The government will invest £800 million to convert the plant to electric arc furnace production.",
            imageURL: "https://picsum.photos/seed/steel-plant/800/500",
            location: "Scunthorpe, UK"
        ),
        Article(
            headline: "UK Passes Landmark AI Safety Act",
            publisher: "The Guardian",
            tags: ["AI", "Policy", "Tech"],
            publishedAt: "2d ago",
            body: "Parliament has passed the AI Safety and Standards Act, creating a new regulatory body with powers to audit frontier AI systems, require safety evaluations before deployment, and impose fines of up to 10% of global revenue for breaches.\n\nThe legislation is narrower than the EU AI Act, focusing exclusively on the highest-capability models rather than applying across all AI applications. Tech industry groups broadly welcomed the more targeted approach.",
            imageURL: "https://picsum.photos/seed/uk-tech-law/800/500",
            location: "London, UK"
        ),
        Article(
            headline: "Rolls-Royce Small Nuclear Reactors Approved for Deployment",
            publisher: "BBC",
            tags: ["Energy", "Tech", "Policy"],
            publishedAt: "3d ago",
            body: "Rolls-Royce's small modular reactor design has received generic design assessment approval from the UK's nuclear regulators — the first SMR design to clear this stage in any western country. Three sites have been identified for initial deployment.\n\nEach unit generates 470 megawatts and can be factory-built in modules, potentially reducing construction time and cost compared to large-scale nuclear projects. The first plant is targeted for operation by 2033.",
            imageURL: "https://picsum.photos/seed/nuclear-reactor/800/500",
            location: "UK"
        ),
    ]

    // MARK: – USA
    static let usa: [Article] = [
        Article(
            headline: "Federal Reserve Signals Two Rate Cuts Before Year End",
            publisher: "Bloomberg",
            tags: ["Finance", "Economy"],
            publishedAt: "3h ago",
            body: "Federal Reserve Chair Jerome Powell indicated in congressional testimony that the committee projects two quarter-point rate reductions before the end of the year, contingent on inflation continuing its descent toward the 2% target.\n\nMarkets reacted positively, with the S&P 500 gaining 1.4% on the session. Bond yields fell across the curve, with the 10-year Treasury dropping to 4.12%.",
            imageURL: "https://picsum.photos/seed/federal-reserve/800/500",
            location: "Washington DC, USA"
        ),
        Article(
            headline: "Congress Passes Bipartisan AI Regulation Framework",
            publisher: "Reuters",
            tags: ["AI", "Policy", "Tech"],
            publishedAt: "1d ago",
            body: "The US Senate has passed the AI Accountability and Transparency Act by 67 votes to 31, marking one of the first major pieces of bipartisan technology legislation in years. The bill requires companies developing frontier AI models to register with a new federal office and submit to independent audits.\n\nThe House is expected to pass a companion bill next week. Tech industry groups are divided — larger companies broadly support the framework while smaller developers argue the compliance costs will entrench incumbents.",
            imageURL: "https://picsum.photos/seed/us-congress/800/500",
            location: "Washington DC, USA"
        ),
        Article(
            headline: "California Mandates 100% Zero-Emission New Car Sales by 2030",
            publisher: "AP News",
            tags: ["Climate", "Policy", "Transport"],
            publishedAt: "2d ago",
            body: "California's Air Resources Board has tightened its Advanced Clean Cars regulation to require that 100% of new passenger vehicle sales be zero-emission by 2030, five years earlier than the previous target. Eleven other states that follow California emissions rules will adopt the same standard.\n\nAutomakers have lobbied against the accelerated timeline, arguing that charging infrastructure and battery supply chains cannot scale fast enough. The state has committed $5 billion for infrastructure expansion in response.",
            imageURL: "https://picsum.photos/seed/california-ev/800/500",
            location: "California, USA"
        ),
        Article(
            headline: "Silicon Valley Layoffs Continue as AI Reshapes Tech Hiring",
            publisher: "TechCrunch",
            tags: ["Tech", "Business", "AI"],
            publishedAt: "5h ago",
            body: "Major technology companies have collectively eliminated 45,000 roles in the first quarter while simultaneously growing their AI and infrastructure teams. The net headcount effect is roughly neutral, but the skills composition of the workforce is shifting rapidly.\n\nData scientists, ML engineers, and inference infrastructure specialists are in extreme demand, while mid-level software generalists are finding the market significantly more competitive than two years ago.",
            imageURL: "https://picsum.photos/seed/silicon-valley/800/500",
            location: "California, USA"
        ),
        Article(
            headline: "Supreme Court Rules on Social Media Content Moderation Powers",
            publisher: "AP News",
            tags: ["Law", "Policy", "Tech"],
            publishedAt: "1d ago",
            body: "The US Supreme Court has ruled 6-3 that states cannot impose laws compelling social media platforms to carry all user speech without moderation, affirming that platforms retain First Amendment editorial discretion. The decision strikes down legislation from Texas and Florida.\n\nThe ruling clarifies a significant area of constitutional uncertainty for the industry, though the Court explicitly left open questions about government-compelled platform behaviour in narrower contexts.",
            imageURL: "https://picsum.photos/seed/supreme-court/800/500",
            location: "Washington DC, USA"
        ),
        Article(
            headline: "US Infrastructure Bill Allocates $80B for National Rail Expansion",
            publisher: "Reuters",
            tags: ["Transport", "Policy"],
            publishedAt: "3d ago",
            body: "The Biden-era infrastructure package's rail component is entering its largest disbursement phase, with $80 billion in grants released to Amtrak and state rail authorities for electrification, high-speed upgrades, and new corridor construction.\n\nThe Northeast Corridor electrification project and California's long-delayed high-speed rail line are the largest recipients. The funding is expected to create approximately 150,000 construction jobs over five years.",
            imageURL: "https://picsum.photos/seed/us-rail/800/500",
            location: "USA"
        ),
        Article(
            headline: "Texas Data Centre Boom Strains State Power Grid Capacity",
            publisher: "The Verge",
            tags: ["Tech", "Energy"],
            publishedAt: "2d ago",
            body: "Texas has approved more than 40 gigawatts of new data centre capacity over the past 18 months, with hyperscalers and AI compute operators drawn by cheap land, loose regulation, and historically low electricity prices. ERCOT, the state's grid operator, warns the approvals now exceed planned generation additions through 2028.\n\nGrid experts are calling for mandatory demand flexibility requirements in data centre operating licences. Several facilities have begun co-locating with natural gas peaker plants to secure their own supply.",
            imageURL: "https://picsum.photos/seed/texas-datacenter/800/500",
            location: "Texas, USA"
        ),
        Article(
            headline: "US-China Trade Tensions Escalate Over Semiconductor Controls",
            publisher: "Bloomberg",
            tags: ["Politics", "Economy", "Tech"],
            publishedAt: "4h ago",
            body: "The Biden administration's export controls on advanced semiconductors and chip-making equipment to China have been extended and tightened, adding 28 new Chinese entities to the restricted list. China has responded with export restrictions on gallium and germanium — materials used in compound semiconductors.\n\nIndustry analysts estimate the controls have delayed China's most advanced chip production by approximately three years, but warn that domestic Chinese alternatives are advancing faster than initially expected.",
            imageURL: "https://picsum.photos/seed/us-china-trade/800/500",
            location: "USA"
        ),
    ]

    // MARK: – Germany
    static let germany: [Article] = [
        Article(
            headline: "German Coalition Collapses Ahead of Snap Federal Elections",
            publisher: "DW",
            tags: ["Politics", "Policy"],
            publishedAt: "2h ago",
            body: "Germany's three-party coalition government has collapsed after the Free Democrats withdrew over disagreements on the federal budget deficit and constitutional debt brake reform. Federal elections are expected within 60 days.\n\nPoll projections show the CDU/CSU leading with approximately 32%, followed by the SPD at 19% and the AfD at 18%. No combination of centre and centre-left parties appears to command a clear majority.",
            imageURL: "https://picsum.photos/seed/bundestag/800/500",
            location: "Berlin, Germany"
        ),
        Article(
            headline: "Volkswagen Announces €10B Investment in Next-Generation EV Platform",
            publisher: "Reuters",
            tags: ["Business", "Transport", "Tech"],
            publishedAt: "4h ago",
            body: "Volkswagen Group has committed €10 billion to a new electric vehicle platform that will underpin models across VW, Audi, and Skoda from 2027. The platform is designed to reduce production costs by 40% compared to current EV models and will be manufactured at the Wolfsburg and Zwickau plants.\n\nThe announcement accompanies a restructuring that will reduce overall headcount by 35,000 positions over three years, the largest workforce reduction in the company's history.",
            imageURL: "https://picsum.photos/seed/volkswagen/800/500",
            location: "Wolfsburg, Germany"
        ),
        Article(
            headline: "Berlin Housing Shortage Reaches Crisis Point With 100,000 Waitlist",
            publisher: "DW",
            tags: ["Society", "Policy"],
            publishedAt: "6h ago",
            body: "Berlin's public housing waitlist has reached 100,000 households for the first time, with average waiting times now exceeding nine years for a social housing unit. Average private rents in the city have risen 32% in three years despite rent control legislation.\n\nThe city government has proposed compulsory purchase powers for properties left empty for more than 18 months, a measure that faces legal challenges from property industry groups.",
            imageURL: "https://picsum.photos/seed/berlin-housing/800/500",
            location: "Berlin, Germany"
        ),
        Article(
            headline: "Germany Reactivates Two Nuclear Plants Amid Winter Energy Concerns",
            publisher: "Financial Times",
            tags: ["Energy", "Policy"],
            publishedAt: "1d ago",
            body: "The German government has reversed course on nuclear energy, announcing the reactivation of two plants mothballed in 2023 to address electricity shortfalls that have pushed industrial power prices to among the highest in the G7.\n\nThe decision marks a significant departure from decades of anti-nuclear consensus in German politics and has divided the governing coalition. The plants are expected to be operational within six months.",
            imageURL: "https://picsum.photos/seed/nuclear-germany/800/500",
            location: "Germany"
        ),
        Article(
            headline: "SAP Acquires AI Startup to Strengthen Enterprise Software Suite",
            publisher: "TechCrunch",
            tags: ["AI", "Business", "Tech"],
            publishedAt: "3h ago",
            body: "SAP has agreed to acquire an enterprise AI startup for €2.4 billion, adding a natural language querying layer and automated workflow generation to its core ERP platform. The deal is the largest acquisition in SAP's history.\n\nThe target's technology allows non-technical business users to query and reorganise enterprise data using plain language commands, a capability SAP says will be integrated into all its cloud products by the end of next year.",
            imageURL: "https://picsum.photos/seed/enterprise-software/800/500",
            location: "Walldorf, Germany"
        ),
        Article(
            headline: "Frankfurt Overtakes Amsterdam as Europe's Largest Stock Exchange",
            publisher: "Financial Times",
            tags: ["Finance", "Business"],
            publishedAt: "2d ago",
            body: "Deutsche Börse's Frankfurt Stock Exchange has surpassed Euronext Amsterdam in total equity market capitalisation for the first time since Brexit reshuffled European financial geography, largely due to the strong performance of German industrial and chemical stocks.\n\nThe shift has reignited debate about whether London's departure from the EU has permanently reoriented European capital markets toward the continent, or whether it reflects a temporary sector-driven fluctuation.",
            imageURL: "https://picsum.photos/seed/frankfurt/800/500",
            location: "Frankfurt, Germany"
        ),
        Article(
            headline: "Germany Reaches 62% Renewable Share in Electricity Generation",
            publisher: "Reuters",
            tags: ["Climate", "Energy"],
            publishedAt: "3d ago",
            body: "Germany generated 62% of its electricity from renewable sources in the first half of the year — a new national record — led by onshore wind at 31% and solar photovoltaic at 18%. The milestone comes despite the controversy over nuclear plant closures.\n\nThe Federal Network Agency cautioned that dispatchable backup capacity remains insufficient for long periods of low wind and solar output, and called for accelerated investment in battery storage and hydrogen peakers.",
            imageURL: "https://picsum.photos/seed/germany-solar/800/500",
            location: "Germany"
        ),
    ]

    // MARK: – France
    static let france: [Article] = [
        Article(
            headline: "French Government Survives No-Confidence Vote by 11 Seats",
            publisher: "Le Monde",
            tags: ["Politics", "Policy"],
            publishedAt: "5h ago",
            body: "The French prime minister's government survived a no-confidence motion by 11 votes in the National Assembly, after the centre-right Republican bloc declined at the last moment to support the opposition motion over the budget deficit trajectory.\n\nThe result leaves the government in a fragile position ahead of the annual budget debate, where it must pass spending cuts equivalent to 1.5% of GDP without a parliamentary majority.",
            imageURL: "https://picsum.photos/seed/paris-assembly/800/500",
            location: "Paris, France"
        ),
        Article(
            headline: "LVMH Reports Slowdown in Luxury Goods Demand From China",
            publisher: "Bloomberg",
            tags: ["Business", "Finance", "Economy"],
            publishedAt: "2h ago",
            body: "LVMH Moët Hennessy Louis Vuitton has reported a 9% decline in revenues from its Asia-Pacific division, with management attributing the fall to weakening consumer confidence among Chinese luxury buyers and a shift toward domestic brands.\n\nThe results sent shares down 5.4% and weighed on European luxury sector stocks broadly. Analysts at Bernstein downgraded the sector to neutral, noting that Chinese luxury demand recovery has been slower and more uneven than forecast.",
            imageURL: "https://picsum.photos/seed/luxury-paris/800/500",
            location: "Paris, France"
        ),
        Article(
            headline: "France Announces Nuclear Renaissance With Six New Reactors",
            publisher: "Reuters",
            tags: ["Energy", "Policy", "Tech"],
            publishedAt: "1d ago",
            body: "French President Emmanuel Macron has confirmed government approval and funding for six new EPR2 nuclear reactors, with the first expected to enter operation by 2035. The programme represents the first new French nuclear construction since the 1990s.\n\nThe reactors are intended to ensure France maintains its current 70% nuclear share of electricity generation as the existing fleet ages. EDF will lead construction, backed by €50 billion in state financing.",
            imageURL: "https://picsum.photos/seed/nuclear-france/800/500",
            location: "France"
        ),
        Article(
            headline: "Airbus Secures 500-Plane Order From Asian Carriers",
            publisher: "Financial Times",
            tags: ["Business", "Transport"],
            publishedAt: "3h ago",
            body: "Airbus has announced a framework order for 500 A320neo family aircraft from a consortium of five Asian carriers, the largest single order by aircraft number in aviation history. Deliveries are spread over ten years starting in 2027.\n\nThe order is a significant setback for Boeing, which had been competing for a portion of the business and is struggling with production certification issues for its 737 MAX 10 variant.",
            imageURL: "https://picsum.photos/seed/airbus/800/500",
            location: "Toulouse, France"
        ),
        Article(
            headline: "France Leads EU Push for AI Copyright Framework",
            publisher: "The Guardian",
            tags: ["AI", "Policy", "Tech"],
            publishedAt: "4h ago",
            body: "France has proposed draft legislation requiring AI companies to disclose all copyrighted works used in training datasets and to pay a statutory licence fee to rightsholders. The proposal has the backing of Spain and Italy and is being presented as a template for EU-wide regulation.\n\nThe initiative has faced pushback from the US government, which argues the proposed fees would disadvantage American AI companies operating in European markets under trade agreement provisions.",
            imageURL: "https://picsum.photos/seed/france-law/800/500",
            location: "Paris, France"
        ),
        Article(
            headline: "Paris Metro Line 18 Opens Connecting Plateau de Saclay to CDG",
            publisher: "Le Monde",
            tags: ["Transport", "Society"],
            publishedAt: "2d ago",
            body: "The first operational section of Grand Paris Express Line 18 has opened, linking the Plateau de Saclay technology cluster to Orly Airport. The 35-kilometre line will eventually extend to Charles de Gaulle Airport, completing a ring around the Île-de-France region.\n\nThe opening reduces commute times between Saclay and the city centre from over an hour to 28 minutes, a change expected to accelerate the cluster's development as a European science and technology hub.",
            imageURL: "https://picsum.photos/seed/paris-metro/800/500",
            location: "Paris, France"
        ),
    ]

    // MARK: – Geopolitics & War
    static let geopolitics: [Article] = [
        Article(
            headline: "Ukraine Receives Expanded Air Defence Package From EU Allies",
            publisher: "Reuters",
            tags: ["Politics", "Defense"],
            publishedAt: "3h ago",
            body: "Six EU member states have jointly announced a new air defence package for Ukraine worth €4.2 billion, including Patriot interceptor batteries and short-range SHORAD systems. The announcement comes after a series of large-scale Russian strikes on civilian infrastructure.\n\nThe package is the largest coordinated European air defence transfer to date and is intended to protect energy infrastructure ahead of the coming winter season.",
            imageURL: "https://picsum.photos/seed/ukraine-defense/800/500",
            location: "Ukraine"
        ),
        Article(
            headline: "Ceasefire Talks Resume in Istanbul After Weeks of Stalemate",
            publisher: "Al Jazeera",
            tags: ["Politics", "War"],
            publishedAt: "5h ago",
            body: "Diplomatic representatives from Ukraine, Russia, and mediating states including Turkey and Saudi Arabia have resumed talks in Istanbul after a 47-day pause, according to three people briefed on the proceedings. The agenda focuses on a humanitarian corridor framework rather than a full ceasefire.\n\nBoth sides have set preconditions that analysts describe as incompatible, making a comprehensive agreement unlikely in the near term. The talks are widely seen as an attempt to establish communication channels rather than produce immediate results.",
            imageURL: "https://picsum.photos/seed/istanbul-diplomacy/800/500"
        ),
        Article(
            headline: "Russian Oil Revenue Falls 28% as Sanctions Tighten",
            publisher: "Bloomberg",
            tags: ["Finance", "Politics"],
            publishedAt: "2d ago",
            body: "Russia's federal budget oil and gas revenues fell 28% year-on-year in the first quarter, according to Russian finance ministry data, as the G7 price cap and shipping restrictions have increasingly limited the country's ability to sell crude above $60 per barrel.\n\nThe shortfall has forced the Russian government to draw on its National Wealth Fund at an accelerated rate. At current withdrawal rates, the fund is projected to be depleted within 18 months.",
            imageURL: "https://picsum.photos/seed/russia-economy/800/500",
            location: "Russia"
        ),
        Article(
            headline: "NATO Expands Eastern Flank With New Rapid Reaction Units",
            publisher: "Reuters",
            tags: ["Defense", "Politics"],
            publishedAt: "1d ago",
            body: "NATO defence ministers have agreed to station two new multinational battle groups in Romania and Slovakia, bringing the total number of enhanced forward presence groups to ten. The new formations will be fully operational within 12 months.\n\nThe decision follows a reassessment of the alliance's eastern deterrence posture that concluded existing forces were insufficient to prevent a rapid territorial incursion and would need to be reinforced within days rather than weeks.",
            imageURL: "https://picsum.photos/seed/nato/800/500"
        ),
        Article(
            headline: "Black Sea Grain Corridor Faces Renewed Disruption Risk",
            publisher: "Al Jazeera",
            tags: ["Food", "Politics", "Economy"],
            publishedAt: "3d ago",
            body: "Shipping companies operating under the Black Sea grain corridor framework have reported a 40% reduction in vessel bookings following a series of near-miss incidents involving naval mines. Two cargo ships have sustained minor damage in the past month.\n\nThe corridor is currently operating at 60% of its 2023 peak volume. Food security organisations warn that any further disruption would accelerate price increases for wheat and sunflower oil in North Africa and the Middle East.",
            imageURL: "https://picsum.photos/seed/black-sea/800/500"
        ),
        Article(
            headline: "Moldova Signs EU Accession Treaty After Record Negotiations",
            publisher: "Reuters",
            tags: ["Politics", "Policy"],
            publishedAt: "2d ago",
            body: "Moldova has signed an EU accession treaty, becoming the first post-Soviet state to complete full accession negotiations since the Baltic countries in 2004. The process took 22 months — the fastest in EU history — reflecting the political urgency around stability in the eastern neighbourhood.\n\nMoldova must implement approximately 300 legislative reforms before full membership rights take effect, a process expected to take two to three years.",
            imageURL: "https://picsum.photos/seed/moldova-eu/800/500",
            location: "Moldova"
        ),
        Article(
            headline: "Gaza Reconstruction Plan Unveiled at Brussels Conference",
            publisher: "Al Jazeera",
            tags: ["Politics", "Policy"],
            publishedAt: "1d ago",
            body: "International donors meeting in Brussels have pledged $22 billion for a phased Gaza reconstruction programme over ten years, conditional on a sustained ceasefire and a defined governance transition plan. The EU and Gulf states are the largest contributors.\n\nThe plan involves the complete reconstruction of approximately 60% of Gaza's residential and civilian infrastructure, which UN assessors estimate was damaged or destroyed during the conflict.",
            imageURL: "https://picsum.photos/seed/reconstruction/800/500"
        ),
    ]

    // MARK: – India
    static let india: [Article] = [
        Article(
            headline: "India's Tech Sector Produces Twelve New Unicorns in Q1",
            publisher: "TechCrunch",
            tags: ["Business", "Tech", "Finance"],
            publishedAt: "2d ago",
            body: "India minted twelve new unicorn startups in the first quarter, led by fintech, agritech, and enterprise SaaS companies. The total brings the country's active unicorn count to 118, second only to the United States and China.\n\nMumbai and Bengaluru account for three quarters of the new companies, though tier-two cities including Pune and Hyderabad are increasingly home to growth-stage companies that have outgrown co-working incubators.",
            imageURL: "https://picsum.photos/seed/india-startup/800/500",
            location: "India"
        ),
        Article(
            headline: "India Launches Third Lunar Mission Targeting South Pole Water Ice",
            publisher: "AP News",
            tags: ["Space", "Science"],
            publishedAt: "3h ago",
            body: "ISRO has successfully launched Chandrayaan-4, India's third lunar mission, carrying a rover designed to drill two metres below the lunar surface in the south polar region in search of water ice deposits. The mission follows the historic success of Chandrayaan-3.\n\nIndia is the first country to attempt subsurface extraction of water ice on the Moon, and the findings will inform both scientific understanding of the early Solar System and future crewed mission planning.",
            imageURL: "https://picsum.photos/seed/india-space/800/500",
            location: "India"
        ),
        Article(
            headline: "Delhi Air Quality Emergency as Pollution Hits Five-Year High",
            publisher: "The Guardian",
            tags: ["Climate", "Society", "Health"],
            publishedAt: "4h ago",
            body: "Delhi authorities have declared an air quality emergency after the city's AQI index exceeded 450 — categorised as hazardous — for five consecutive days. Schools have been closed and outdoor construction halted under emergency protocols.\n\nCrop stubble burning in Punjab and Haryana, combined with Diwali firecrackers and low wind speeds, produced the worst pollution episode since 2019. The Supreme Court has issued a directive requiring the government to report on enforcement of anti-burning regulations within 48 hours.",
            imageURL: "https://picsum.photos/seed/delhi-pollution/800/500",
            location: "Delhi, India"
        ),
        Article(
            headline: "India's High-Speed Rail Reaches 2,000km Operational Milestone",
            publisher: "Reuters",
            tags: ["Transport", "Business"],
            publishedAt: "2d ago",
            body: "India's high-speed rail network, built with Japanese Shinkansen technology, has reached 2,000 kilometres of operational track following the inauguration of the Mumbai-Ahmedabad corridor's final section. Journey time between the two cities is now 2 hours 7 minutes, down from over 7 hours by conventional rail.\n\nThe government has fast-tracked approval for four additional high-speed corridors connecting Delhi, Chennai, Kolkata, and Bengaluru, with construction beginning next year.",
            imageURL: "https://picsum.photos/seed/india-rail/800/500",
            location: "India"
        ),
        Article(
            headline: "Tata Group Acquires UK Semiconductor Design Firm for £2.4B",
            publisher: "Financial Times",
            tags: ["Business", "Tech"],
            publishedAt: "1d ago",
            body: "Tata Group has agreed to acquire a Cambridge-based semiconductor design firm in a deal valued at £2.4 billion, gaining access to a portfolio of ARM-based chip designs used in automotive and industrial IoT applications.\n\nThe acquisition marks Tata's most significant step into the semiconductor value chain and is expected to be approved by the UK government, which has signalled that the country's semiconductor intellectual property should remain accessible to allied nations.",
            imageURL: "https://picsum.photos/seed/tata-uk/800/500",
            location: "India"
        ),
        Article(
            headline: "Mumbai Fintech Sector Reaches $50B Valuation as UPI Expands",
            publisher: "Bloomberg",
            tags: ["Finance", "Tech"],
            publishedAt: "3d ago",
            body: "India's fintech ecosystem has reached a combined valuation of $50 billion, driven by the rapid internationalisation of the Unified Payments Interface which now operates in 12 countries including France, Singapore, and the UAE.\n\nThe Reserve Bank of India's regulatory sandbox approach has been credited with allowing rapid iteration by startups while maintaining systemic safeguards. International investors are increasingly treating Indian fintech as a template for developing market financial infrastructure.",
            imageURL: "https://picsum.photos/seed/mumbai-fintech/800/500",
            location: "Mumbai, India"
        ),
    ]

    // MARK: – China
    static let china: [Article] = [
        Article(
            headline: "China's Economy Grows 4.9% as Consumer Spending Recovers",
            publisher: "Bloomberg",
            tags: ["Economy", "Finance"],
            publishedAt: "4h ago",
            body: "China's economy expanded 4.9% in the first quarter, marginally below the government's 5% annual target but above analyst consensus of 4.6%. Retail sales growth of 7.2% was the strongest in five quarters, driven by domestic tourism and electronics.\n\nProperty sector investment remains negative but has narrowed from a 10% year-on-year decline to 3%, suggesting that the government's support measures for distressed developers are beginning to stabilise the market.",
            imageURL: "https://picsum.photos/seed/china-economy/800/500",
            location: "China"
        ),
        Article(
            headline: "BYD Overtakes Tesla in Global EV Sales for Second Consecutive Year",
            publisher: "Reuters",
            tags: ["Business", "Transport", "Tech"],
            publishedAt: "2d ago",
            body: "BYD delivered 1.76 million battery electric vehicles in the first half of the year, compared to Tesla's 1.33 million — a gap that has widened from 200,000 units in the same period last year. BYD's advantage is most pronounced in the sub-$30,000 segment where it has no direct Tesla competitor.\n\nBYD has now opened manufacturing facilities in Hungary, Brazil, and Thailand to circumvent import tariffs and is targeting 50% of sales volume from outside China by 2027.",
            imageURL: "https://picsum.photos/seed/byd-ev/800/500",
            location: "China"
        ),
        Article(
            headline: "Beijing Tightens AI Content Regulations for Domestic Platforms",
            publisher: "The Verge",
            tags: ["AI", "Policy", "Tech"],
            publishedAt: "1d ago",
            body: "China's Cyberspace Administration has issued new rules requiring all AI-generated content to carry visible watermarks and mandating that generative AI services obtain separate licences for news, financial, and medical content categories.\n\nThe regulations expand on last year's interim measures and apply to both Chinese companies and foreign services operating in China. Non-compliance carries fines of up to 500,000 yuan and potential licence suspension.",
            imageURL: "https://picsum.photos/seed/china-ai/800/500",
            location: "Beijing, China"
        ),
        Article(
            headline: "China Restricts Rare Earth Processing Exports in Trade Retaliation",
            publisher: "Financial Times",
            tags: ["Economy", "Policy", "Tech"],
            publishedAt: "3h ago",
            body: "China's Ministry of Commerce has announced restrictions on the export of refined rare earth compounds — the processed forms used directly in magnets, batteries, and electronics — while leaving raw ore exports largely unrestricted. The move targets the processing stage where China has near-total global market share.\n\nThe measure is widely interpreted as a calibrated response to US semiconductor export controls and is expected to affect European and Japanese manufacturers of EV motors and wind turbine generators most acutely.",
            imageURL: "https://picsum.photos/seed/rare-earth/800/500",
            location: "China"
        ),
        Article(
            headline: "Alibaba Restructuring Creates Five Independent Business Units",
            publisher: "Bloomberg",
            tags: ["Business", "Tech"],
            publishedAt: "2d ago",
            body: "Alibaba Group has completed its restructuring into five independent business units — cloud, e-commerce, logistics, digital entertainment, and international commerce — each with its own board and the option to pursue separate capital market listings.\n\nThe cloud unit, which competes with AWS and Azure in Asian markets, is considered the most likely near-term IPO candidate and has been valued at approximately $110 billion by analysts at Macquarie.",
            imageURL: "https://picsum.photos/seed/alibaba/800/500",
            location: "Hangzhou, China"
        ),
        Article(
            headline: "Shenzhen Announces Citywide AI Infrastructure Integration",
            publisher: "TechCrunch",
            tags: ["AI", "Tech", "Policy"],
            publishedAt: "3d ago",
            body: "Shenzhen's municipal government has launched a programme to integrate AI systems into traffic management, waste collection, building permits, and healthcare triage across all 10 districts. The project, budgeted at ¥28 billion, is described as the most comprehensive smart city deployment attempted at this scale.\n\nCritical infrastructure AI systems must use domestically produced chips and models, a requirement that has accelerated the commercialisation of Huawei Ascend and Cambricon hardware in the municipal market.",
            imageURL: "https://picsum.photos/seed/shenzhen-smart/800/500",
            location: "Shenzhen, China"
        ),
    ]

    // MARK: – Brazil
    static let brazil: [Article] = [
        Article(
            headline: "Amazon Deforestation Falls 45% Under New Enforcement Push",
            publisher: "The Guardian",
            tags: ["Climate", "Policy", "Science"],
            publishedAt: "2d ago",
            body: "Brazil's space research agency INPE has recorded a 45% reduction in Amazon deforestation in the 12 months to June, compared to the same period under the previous administration. The decline is attributed to increased federal enforcement operations and the reactivation of monitoring programmes that had been defunded.\n\nThe improvement has been welcomed by international climate negotiators but scientists caution that secondary forest degradation — which does not show up in deforestation statistics — continues at a significant rate.",
            imageURL: "https://picsum.photos/seed/amazon-forest/800/500",
            location: "Brazil"
        ),
        Article(
            headline: "Brazil's Real Hits Record Low Amid Fiscal Deficit Concerns",
            publisher: "Bloomberg",
            tags: ["Finance", "Economy"],
            publishedAt: "5h ago",
            body: "The Brazilian real has weakened to a record low of R$5.85 per US dollar, driven by investor concerns over the government's projected fiscal deficit of 1.3% of GDP for the current year and uncertainty over the independence of the central bank under its new governor.\n\nBrazil's central bank raised its benchmark Selic rate by 50 basis points to 12.25% in an emergency inter-meeting decision, the first such move since 2002.",
            imageURL: "https://picsum.photos/seed/brazil-finance/800/500",
            location: "Brazil"
        ),
        Article(
            headline: "Petrobras Announces Offshore Discovery of 2 Billion Barrel Reserve",
            publisher: "Reuters",
            tags: ["Energy", "Business"],
            publishedAt: "3d ago",
            body: "Brazil's state oil company Petrobras has confirmed a pre-salt oil discovery in the Campos Basin estimated at 2 billion recoverable barrels — the largest domestic discovery in over a decade. The field is located 300 kilometres offshore at a depth of 2,400 metres.\n\nThe discovery complicates Brazil's stated climate commitments, as development of the field would extend Brazil's hydrocarbon production profile well into the 2040s.",
            imageURL: "https://picsum.photos/seed/offshore-oil/800/500",
            location: "Brazil"
        ),
        Article(
            headline: "Rio de Janeiro G20 Summit Concludes With Infrastructure Accord",
            publisher: "Reuters",
            tags: ["Politics", "Economy"],
            publishedAt: "4d ago",
            body: "The G20 summit hosted by Brazil in Rio de Janeiro concluded with an accord committing member states to coordinate infrastructure investment of $5 trillion over five years in low and middle income countries, with a focus on clean energy, digital connectivity, and water systems.\n\nThe accord is non-binding but establishes a common reporting framework and a multilateral coordination mechanism that proponents say will reduce duplication and improve capital allocation.",
            imageURL: "https://picsum.photos/seed/rio-g20/800/500",
            location: "Rio de Janeiro, Brazil"
        ),
    ]

    // MARK: – Japan
    static let japan: [Article] = [
        Article(
            headline: "Bank of Japan Raises Interest Rates to 0.75% in Historic Shift",
            publisher: "Bloomberg",
            tags: ["Finance", "Economy"],
            publishedAt: "6h ago",
            body: "The Bank of Japan has raised its policy rate to 0.75%, the highest level since 1994, as sustained wage growth and core inflation above 2% for 28 consecutive months gave the board confidence to continue normalising monetary policy.\n\nThe yen strengthened 2.1% against the dollar on the announcement. Japanese government bond yields rose sharply, with the 10-year JGB reaching 1.45% — a level not seen since 2008.",
            imageURL: "https://picsum.photos/seed/tokyo-finance/800/500",
            location: "Tokyo, Japan"
        ),
        Article(
            headline: "Sony Acquires US Gaming Studio in $3.6B Deal",
            publisher: "The Verge",
            tags: ["Business", "Tech"],
            publishedAt: "1d ago",
            body: "Sony Interactive Entertainment has agreed to acquire a mid-tier US game development studio for $3.6 billion, its largest acquisition since Bungie in 2022. The studio is best known for an online multiplayer franchise with 45 million active players.\n\nThe deal strengthens PlayStation's live-service portfolio at a time when Microsoft's Xbox Game Pass has attracted significant subscriber numbers. Sony's strategy has shifted toward building owned live-service properties rather than relying on third-party timed exclusives.",
            imageURL: "https://picsum.photos/seed/gaming-sony/800/500",
            location: "Japan"
        ),
        Article(
            headline: "Japan and ESA Announce Joint Lunar Resource Mapping Mission",
            publisher: "Space.com",
            tags: ["Space", "Science"],
            publishedAt: "2d ago",
            body: "The Japan Aerospace Exploration Agency and European Space Agency have announced a joint mission to map mineral and water ice resources across the lunar south polar region. The mission will use a combination of orbital radar and two small landers to produce the highest-resolution resource map of any lunar region to date.\n\nThe data will be made available to all signatory nations of the Artemis Accords and is intended to inform the siting of future crewed surface facilities.",
            imageURL: "https://picsum.photos/seed/japan-moon/800/500",
            location: "Japan"
        ),
        Article(
            headline: "Japan's Ageing Population Exceeds 30% of Total for First Time",
            publisher: "Reuters",
            tags: ["Society", "Economy"],
            publishedAt: "3d ago",
            body: "Japan's Statistics Bureau has confirmed that citizens aged 65 and over now account for 30.1% of the total population — the highest proportion in any G7 country and the first time any major economy has crossed the 30% threshold.\n\nThe demographic shift is intensifying pressure on the public pension system and healthcare budget. The government has proposed raising the retirement age to 70 for public sector workers and expanding immigration pathways for healthcare professionals.",
            imageURL: "https://picsum.photos/seed/japan-society/800/500",
            location: "Japan"
        ),
    ]

    // MARK: – Australia
    static let australia: [Article] = [
        Article(
            headline: "Australia Launches A$20B Clean Energy Transition Fund",
            publisher: "Reuters",
            tags: ["Climate", "Energy", "Policy"],
            publishedAt: "1d ago",
            body: "The Australian government has launched a A$20 billion sovereign green investment fund to accelerate the transition from coal-fired power and develop the country's renewable energy export capacity. The fund will co-invest with private capital in offshore wind, green hydrogen, and grid infrastructure.\n\nAustralia has committed to 82% renewable electricity by 2030 and is positioning itself as a major supplier of green hydrogen to Japan, South Korea, and Germany under long-term offtake agreements currently being negotiated.",
            imageURL: "https://picsum.photos/seed/australia-solar/800/500",
            location: "Australia"
        ),
        Article(
            headline: "Australia Bans Social Media for Under-16s With New Legislation",
            publisher: "BBC",
            tags: ["Policy", "Tech", "Society"],
            publishedAt: "2h ago",
            body: "Australia has passed legislation banning children under 16 from using social media platforms, imposing fines of up to A$50 million on companies that allow underage users to hold accounts. The law requires platforms to implement age verification systems within 12 months.\n\nThe legislation is the most restrictive of its kind globally. Platforms including TikTok, Instagram, and Snapchat have said age verification at this level is technically challenging and have indicated they will consult legal counsel on compliance pathways.",
            imageURL: "https://picsum.photos/seed/australia-policy/800/500",
            location: "Australia"
        ),
        Article(
            headline: "Great Barrier Reef Bleaching Hits Record for Third Year Running",
            publisher: "The Guardian",
            tags: ["Climate", "Science"],
            publishedAt: "3d ago",
            body: "Aerial surveys conducted by the Australian Institute of Marine Science have found that 73% of surveyed reefs along the Great Barrier Reef experienced some degree of thermal bleaching this season — the third record in three years. The bleaching is caused by sea surface temperatures running 2.1°C above the long-term average.\n\nScientists from James Cook University said that the frequency of bleaching events no longer allows the reef time to recover between episodes, a shift they describe as a transition from stress events to chronic degradation.",
            imageURL: "https://picsum.photos/seed/coral-reef/800/500",
            location: "Queensland, Australia"
        ),
        Article(
            headline: "Sydney Property Prices Rise 11% as Supply Fails to Keep Pace",
            publisher: "Bloomberg",
            tags: ["Finance", "Society"],
            publishedAt: "4h ago",
            body: "Sydney residential property prices have risen 11% over the past 12 months, driven by population growth from skilled migration and a persistently low supply of new dwellings. The median house price in greater Sydney has reached A$1.48 million.\n\nThe Reserve Bank of Australia has flagged housing affordability as a systemic risk in its latest financial stability review, noting that mortgage stress among recent buyers would become acute if rates remained elevated for another 18 months.",
            imageURL: "https://picsum.photos/seed/sydney-property/800/500",
            location: "Sydney, Australia"
        ),
        Article(
            headline: "Australian Lithium Exports Surge as Global EV Demand Grows",
            publisher: "Financial Times",
            tags: ["Energy", "Finance", "Business"],
            publishedAt: "2d ago",
            body: "Australia's lithium export revenues have reached A$18 billion annually, making it the country's fourth largest export commodity behind iron ore, coal, and LNG. Australia supplies approximately 55% of global lithium production, with the majority going to Chinese battery manufacturers.\n\nThe government is actively pursuing downstream investment to move Australian production from raw spodumene toward refined lithium hydroxide and battery-grade chemicals, which command significantly higher prices.",
            imageURL: "https://picsum.photos/seed/lithium-mining/800/500",
            location: "Western Australia, Australia"
        ),
    ]
}
