package com.mooc.backend.entities;

import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import io.hypersistence.utils.hibernate.type.json.JsonType;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Type;

import java.time.LocalDateTime;
import java.util.LinkedHashSet;
import java.util.Set;

@Getter
@Setter
@Entity
@Table(name = "mooc_page_layouts")
public class PageLayout extends Auditable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Type(JsonType.class)
    @Column(columnDefinition = "json", nullable = false)
    private PageConfig config;

    private LocalDateTime startTime;

    private LocalDateTime endTime;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private PageStatus status = PageStatus.DRAFT;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private PageType pageType = PageType.Home;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Platform platform = Platform.APP;

    @OneToMany(mappedBy = "pageLayout", orphanRemoval = true)
    private Set<PageBlock> pageBlocks = new LinkedHashSet<>();

}
